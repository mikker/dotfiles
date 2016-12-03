#!/usr/bin/env ruby
require 'json'
require 'open3'

class LintingError
    def initialize data
        @data = data
    end

    def to_str
        "#{filename}:#{linum}:#{col} [#{type}] #{overview}"
    end

    def linum
        @data['region']['start']['line']
    end

    def col
        @data['region']['start']['column']
    end

    def filename
        @data['file']
    end

    def type
        @data['type'][0].upcase
    end

    def overview
        @data['overview']
    end
end

class JsonResponse
    def initialize response_str
        @response_str = response_str
    end


    def parse
        split_response = @response_str.split "\n"
        output = ""

        for line in split_response
            output += parse_json line + "\n"
        end

        output
    end

    def parse_json line
        json_array = JSON.parse line
        output = ""

        for json in json_array
            err = LintingError.new json
            output += err.to_str + "\n"
        end

        output
    end
end

class NonJsonResponse
    def initialize filename, response_str
        @filename = filename
        @response_str = response_str
    end

    def parse
        # just return response string for now
        # get first line, set linum and col to 1
        "#{@filename}:1:1 [E] #{overview}"
    end

    def overview
        split_response = @response_str.split "\n"
        split_response[0]
    end

end


class ElmLint
    def initialize filepath
        @filepath = filepath
    end

    def find_project_root
        parts = @filepath.split '/'
        found = []

        while parts.any? and found.empty?
            parts.pop
            dir = parts.join '/'
            if Dir.exists? dir
                found = Dir["#{dir}/elm-package.json"]
            end
        end

        parts.join('/')
    end

    def execute

        root = find_project_root
        Dir.chdir root

        stdout, stderr, status = Open3.capture3 "elm-make #{@filepath} --warn --report=json --output /dev/null"

        if stdout.empty?
            @response_str = stderr
        else
            @response_str = stdout
        end

        @exit_code = status.exitstatus

        if @exit_code != 0
            parse
            puts clean_output
        end
        exit @exit_code
    end

    def clean_output
        # remove empty lines
        @output.gsub(/^$\n/, '')
    end

    def parse
        if is_json?
            response = JsonResponse.new @response_str
        else
            response = NonJsonResponse.new @filepath, @response_str
        end
        @output = response.parse
    end

    def is_json?
        @response_str[0] == '['
    end

end



if __FILE__ == $0
    lint = ElmLint.new ARGV[0]
    lint.execute
end
