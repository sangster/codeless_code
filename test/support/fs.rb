# frozen_string_literal: true

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
            .inject(self) { |dir, name| dir.create(name, type: :dir) }
            .create(base.to_s)

      path.open { |io| io.write(body) && io.rewind } if body
      path
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
