# frozen_string_literal: true

# codeless_code filters and prints fables from http://thecodelesscode.com
# Copyright (C) 2018  Jon Sangster
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <https://www.gnu.org/licenses/>.
module Support
  class FakeFile
    attr_reader :name, :path, :body, :parent

    def initialize(name, body = '')
      @name = name
      @body = body

      @parent = nil
      @path = Pathname.new(@name)
    end

    def directory?
      false
    end

    def parent=(par)
      @parent = par
      @parent.files << self
      @path = par.path.join(name)
    end

    def basename
      path.basename
    end

    def glob(str)
      self if path.fnmatch(str) || path.basename.fnmatch(str)
    end

    def io
      @io ||= StringIO.new(body.strip).tap do |io|
        io.define_singleton_method(:open) { self }
        io.define_singleton_method(:close) { self }
      end
    end

    def open
      io.tap do |io|
        io.rewind
        yield io if block_given?
      end
    end

    def close
      io
    end

    def inspect
      format('#<FakeFile %p>', name)
    end
  end

  class FakeDir < FakeFile
    attr_reader :files

    def initialize(name, files = [])
      super(name)
      @files = files
    end

    def directory?
      true
    end

    def parent=(node)
      super(node)
      files.each { |f| f.parent = self }
    end

    def glob(str)
      [super(str), files.map { |f| f.glob(str) }].flatten.compact
    end

    def create_path(path, body = nil)
      dirs, base = Pathname.new(path).split

      path =
        dirs.to_s.split(File::SEPARATOR)
            .inject(self) { |dir, name| dir.get_or_create(name, type: :dir) }
            .create(base.to_s)

      path.open { |io| io.write(body) && io.rewind } if body
      path
    end

    def get_or_create(node_name, type: :file)
      files.find { |f| f.name == node_name } || create(node_name, type: type)
    end

    def create(node_name, type: :file)
      (type == :file ? FakeFile : FakeDir).new(node_name).tap do |file|
        file.parent = self
      end
    end

    def inspect
      format('#<FakeDir %p, files=%p>', name, files)
    end
  end
end
