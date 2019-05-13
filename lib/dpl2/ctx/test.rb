require 'cl'
require 'stringio'

module Dpl
  module Ctx
    class Test < Cl::Ctx
      attr_reader :stderr

      def initialize
        @stderr = StringIO.new
        super('dpl')
      end

      def exists?(path)
        File.exists?(path)
      end

      def fold(name)
        cmds << "[fold] #{name}"
        yield.tap { cmds << "[unfold] #{name}" }
      end

      def apt_get(name, cmd)
        cmds << "[apt:get] #{name} (#{cmd})"
      end

      def npm_install(name, cmd = name)
        cmds << "[npm:install] #{name} (#{cmd})"
      end

      def pip_install(name, cmd = name, version = nil)
        cmds << "[pip:install] #{name} (#{cmd}, #{version})"
      end

      def npm_version
        '1'
      end

      def script(name)
        cmds << "[script] #{name}"
      end

      def shell(cmd, opts = {})
        cmd = "#{cmd} > /dev/null 2>&1" if opts[:silence]
        cmd = "[python:#{opts[:python]}] #{cmd}" if opts[:python]
        cmds << cmd
      end

      def success?
        true
      end

      def info(msg)
        cmds << "[info] #{msg}"
      end

      def print(chars)
        cmds << "[print] #{chars}"
      end

      def warn(msg)
        cmds << "[warn] #{msg}"
      end

      def error(message)
        raise Error, message
      end

      def deprecate_opt(key, msg)
        msg = "please use #{msg}" if msg.is_a?(Symbol)
        warn("deprecated option #{key} (#{msg})")
      end

      def repo_name
        'dpl'
      end

      def repo_slug
        'travis-ci/dpl'
      end

      def build_dir
        '.'
      end

      def build_number
        1
      end

      def git_tag
        'tag'
      end

      def remotes
        ['origin']
      end

      def git_log(args)
        'commits'
      end

      def git_rev_parse(ref)
        "ref: #{ref}"
      end

      def sha
        'sha'
      end

      def commit_msg
        'commit msg'
      end

      def files
        %w(one two)
      end

      def which(cmd)
        false
      end

      def machine_name
        'machine_name'
      end

      def tmpdir
        FileUtils.mkdir_p('tmp')
        'tmp'
      end

      def ssh_keygen(name, file)
        File.open(file, 'w+') { |f| f.write('private-key') }
        File.open("#{file}.pub", 'w+') { |f| f.write('ssh-rsa public-key') }
      end

      def sleep(*)
      end

      def encoding(path)
        'text'
      end

      def logger(level = :info)
        logger = Logger.new(stderr)
        logger.level = Logger.const_get(level.to_s.upcase)
        logger
      end

      def rendezvous(url)
        cmds << "[rendezvous] #{url}"
      end

      def cmds
        @cmds ||= []
      end

      def test?
        true
      end

      def except(hash, *keys)
        hash.reject { |key, _| keys.include?(key) }
      end
    end
  end
end
