#!/usr/bin/env lein exec
(ns combine-m3u8.core
  (:require [clj-http.client :as client])
  (:require [clojure.java.io :as io]))

; (def uri "http://drod01s-vh.akamaihd.net/i/all/clear/streaming/be/54a03a176187a2053cfc4ebe/P6-BEAT-med-Mikael-Simpson-og-_b3ab8d96bb5b4f8380bf0dbe4bee3880_,192,61,.mp4.csmil/master.m3u8")
(def uri "http://www.dr.dk/radio/ondemand/p6beat/p6-beat-med-mikael-simpson-og-jens-unmack-2#!/")

(def filename "tmp.ts")

(defn get-body [uri]
  (:body (client/get uri)))

(defn find-audio-element [body]
  (re-find #"audio[a-z\s]+src" body))

(defn bandwidths-in [repo]
  (let [lines (apply vector (clojure.string/split repo #"\n"))]
    (into {} (map (fn [index line]
                    (let [bwidth (last (re-find #"BANDWIDTH=(\d+)" line))]
                      (if bwidth {bwidth (get lines (inc index))})
                      )) (range) lines))))

(defn find-best-feed [repo]
  (let [bandwidths (bandwidths-in repo)
        best-key (-> bandwidths keys sort first)]
    (get bandwidths best-key)))

(defn files-in-playlist [playlist]
  (let [lines (clojure.string/split (get-body playlist) #"\n")]
    (filter #(re-find #"http.*" %) lines)))

(defn append-to-file [filename uri]
  (with-open [in (io/input-stream uri)
              out (io/output-stream filename :append true)]
    (io/copy in out)))

(defn process-m3u8 [repo]
  (doseq [uri (files-in-playlist (find-best-feed (get-body uri)))]
    (print ".")
    (append-to-file filename uri)))

; (process-m3u8 uri)

; (println "Done")
(println (find-audio-element (get-body uri)))

