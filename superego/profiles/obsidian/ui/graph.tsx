// The graph pane: the vault's notes and their [[links]], laid out by a small force simulation on a canvas. Coloured by
// top folder; drag to pan, scroll to zoom, hover for a title, click a note to open it. `focus` centres on a note.
import { useEffect, useMemo, useRef } from 'react'
import { has, PaneHeader, PaneMessage, PaneNote, useDispatch, useMethod, type PaneProps } from 'superego/ui'
import type { Graph as GraphData } from '../shared.ts'

type Node = { id: string; title: string; folder: string; x: number; y: number; vx: number; vy: number; degree: number }
type Graph = { nodes: Node[]; edges: { from: Node; to: Node }[] }

/** A note's dot, sized by its links; never under a few pixels on screen, however far out. */
const radius = (n: Node, scale: number) => (2.5 + Math.sqrt(n.degree) * 1.4) * Math.max(1, 0.8 / scale)

const PALETTE = ['#007aff', '#34c759', '#ff9500', '#af52de', '#ff2d55', '#5ac8fa', '#a2845e', '#5856d6', '#30b0c7', '#ffcc00']

function layout(nodes: Node[], edges: Graph['edges']) {
  // Start on a circle, then a few hundred steps of springs (links), repulsion (everyone) and a pull to the middle.
  nodes.forEach((n, i) => { const a = (i / nodes.length) * Math.PI * 2; n.x = Math.cos(a) * 300; n.y = Math.sin(a) * 300 })
  for (let step = 0; step < 300; step++) {
    const heat = 1 - step / 300
    for (let i = 0; i < nodes.length; i++) {
      const a = nodes[i]!
      for (let j = i + 1; j < nodes.length; j++) {
        const b = nodes[j]!
        let dx = a.x - b.x, dy = a.y - b.y
        const d2 = dx * dx + dy * dy || 0.01
        if (d2 > 90000) continue
        const f = 900 / d2
        dx *= f; dy *= f
        a.vx += dx; a.vy += dy; b.vx -= dx; b.vy -= dy
      }
    }
    for (const { from, to } of edges) {
      const dx = to.x - from.x, dy = to.y - from.y
      const d = Math.sqrt(dx * dx + dy * dy) || 1
      const f = (d - 50) * 0.02
      from.vx += (dx / d) * f; from.vy += (dy / d) * f; to.vx -= (dx / d) * f; to.vy -= (dy / d) * f
    }
    for (const n of nodes) {
      n.vx -= n.x * 0.002; n.vy -= n.y * 0.002
      n.x += Math.max(-20, Math.min(20, n.vx)) * heat; n.y += Math.max(-20, Math.min(20, n.vy)) * heat
      n.vx *= 0.5; n.vy *= 0.5
    }
  }
}

/** The vault's notes and links, laid out. */
function laidOut({ nodes, edges }: GraphData): Graph {
  const byId = new Map(nodes.map((n) => [n.id, { ...n, x: 0, y: 0, vx: 0, vy: 0, degree: 0 } as Node]))
  const links = edges.map((e) => ({ from: byId.get(e.from)!, to: byId.get(e.to)! })).filter((e) => e.from && e.to)
  for (const { from, to } of links) { from.degree++; to.degree++ }
  layout([...byId.values()], links)
  return { nodes: [...byId.values()], edges: links }
}

export function GraphPane({ machine, thread, pane }: PaneProps) {
  const dispatch = useDispatch()
  const canvas = useRef<HTMLCanvasElement>(null)
  const { data, error } = useMethod<GraphData>(machine.id, 'vault.graph', { thread: thread.id }, { enabled: has(machine, 'ext:vault@^1') })
  const graph = useMemo(() => data && laidOut(data), [data])
  const view = useRef({ x: 0, y: 0, scale: 1, hover: undefined as Node | undefined })
  const focus = (pane.params as { focus?: string } | undefined)?.focus

  const folders = graph ? [...new Set(graph.nodes.map((n) => n.folder))].sort() : []
  const colour = (folder: string) => PALETTE[folders.indexOf(folder) % PALETTE.length]!

  useEffect(() => {
    const el = canvas.current
    if (!el || !graph) return
    const centred = focus && graph.nodes.find((n) => n.id === focus)
    if (centred) Object.assign(view.current, { x: -centred.x * 1.6, y: -centred.y * 1.6, scale: 1.6 })
    else {
      // The whole vault in view, centred on its middle.
      const xs = graph.nodes.map((n) => n.x), ys = graph.nodes.map((n) => n.y)
      const [x0, x1, y0, y1] = [Math.min(...xs), Math.max(...xs), Math.min(...ys), Math.max(...ys)]
      const { width, height } = el.getBoundingClientRect()
      const scale = Math.min(2, (width - 40) / (x1 - x0 || 1), (height - 40) / (y1 - y0 || 1))
      Object.assign(view.current, { x: -((x0 + x1) / 2) * scale, y: -((y0 + y1) / 2) * scale, scale })
    }
    let frame = 0
    const draw = () => {
      const ratio = devicePixelRatio
      const { width, height } = el.getBoundingClientRect()
      if (el.width !== width * ratio) { el.width = width * ratio; el.height = height * ratio }
      const ctx = el.getContext('2d')!
      const dark = matchMedia('(prefers-color-scheme: dark)').matches
      const { x, y, scale, hover } = view.current
      ctx.setTransform(ratio, 0, 0, ratio, 0, 0)
      ctx.clearRect(0, 0, width, height)
      ctx.translate(width / 2 + x, height / 2 + y)
      ctx.scale(scale, scale)
      const near = hover ? new Set(graph.edges.flatMap((e) => e.from === hover ? [e.to] : e.to === hover ? [e.from] : [])) : undefined
      ctx.lineWidth = 0.6 / scale
      for (const { from, to } of graph.edges) {
        const lit = hover && (from === hover || to === hover)
        ctx.strokeStyle = lit ? (dark ? 'rgba(255,255,255,.7)' : 'rgba(0,0,0,.55)') : dark ? 'rgba(255,255,255,.12)' : 'rgba(0,0,0,.1)'
        ctx.beginPath(); ctx.moveTo(from.x, from.y); ctx.lineTo(to.x, to.y); ctx.stroke()
      }
      for (const n of graph.nodes) {
        const r = radius(n, scale)
        ctx.globalAlpha = hover && n !== hover && !near!.has(n) ? 0.25 : 1
        ctx.fillStyle = colour(n.folder)
        ctx.beginPath(); ctx.arc(n.x, n.y, r, 0, Math.PI * 2); ctx.fill()
        if (n.id === focus) { ctx.strokeStyle = dark ? '#fff' : '#000'; ctx.lineWidth = 1.5 / scale; ctx.stroke(); ctx.lineWidth = 0.6 / scale }
      }
      ctx.globalAlpha = 1
      // Titles: the hovered note and its neighbours, and the well-linked ones once zoomed in.
      ctx.font = `${11 / scale}px -apple-system, system-ui, sans-serif`
      ctx.fillStyle = dark ? '#f5f5f7' : '#1d1d1f'
      ctx.textAlign = 'center'
      for (const n of graph.nodes) {
        if (n === hover || near?.has(n) || n.id === focus || (!hover && scale > 1.4 && n.degree >= 3)) ctx.fillText(n.title, n.x, n.y - radius(n, scale) - 4 / scale)
      }
      frame = requestAnimationFrame(draw)
    }
    frame = requestAnimationFrame(draw)
    return () => cancelAnimationFrame(frame)
  }, [graph, focus])

  const at = (event: { clientX: number; clientY: number }) => {
    const el = canvas.current!
    const box = el.getBoundingClientRect()
    const { x, y, scale } = view.current
    const px = (event.clientX - box.left - box.width / 2 - x) / scale, py = (event.clientY - box.top - box.height / 2 - y) / scale
    return graph?.nodes.find((n) => (n.x - px) ** 2 + (n.y - py) ** 2 < (radius(n, scale) + 4 / scale) ** 2)
  }
  const drag = useRef<{ x: number; y: number; moved: boolean } | undefined>(undefined)

  if (error) return <PaneMessage>{error.message}</PaneMessage>
  if (!graph) return <PaneMessage>Reading the vault…</PaneMessage>
  return (
    <div className="vault-graph">
      <PaneHeader>
        <PaneNote>{graph.nodes.length} notes · {graph.edges.length} links</PaneNote>
        <span className="vault-graph__legend">{folders.filter(Boolean).map((f) => <span key={f}><i style={{ background: colour(f) }} />{f}</span>)}</span>
      </PaneHeader>
      <canvas ref={canvas} className="vault-graph__canvas"
        onPointerDown={(e) => { drag.current = { x: e.clientX, y: e.clientY, moved: false }; (e.target as HTMLElement).setPointerCapture(e.pointerId) }}
        onPointerMove={(e) => {
          if (drag.current) {
            const dx = e.clientX - drag.current.x, dy = e.clientY - drag.current.y
            if (Math.abs(dx) + Math.abs(dy) > 2) drag.current.moved = true
            view.current.x += dx; view.current.y += dy
            drag.current.x = e.clientX; drag.current.y = e.clientY
          } else view.current.hover = at(e)
        }}
        onPointerUp={(e) => {
          const moved = drag.current?.moved
          drag.current = undefined
          const node = !moved && at(e)
          if (node) void dispatch('pane.open', { thread: thread.id, kind: 'note', title: node.title, params: { path: node.id } }, { machine: machine.id })
        }}
        onPointerLeave={() => { view.current.hover = undefined }}
        onWheel={(e) => { view.current.scale = Math.min(6, Math.max(0.2, view.current.scale * (e.deltaY < 0 ? 1.1 : 0.9))) }}
      />
    </div>
  )
}
