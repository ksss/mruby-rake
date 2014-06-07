assert 'Rake::DSL#task' do
  runlist = []
  klass = Class.new {
    include Rake::DSL

    define_method(:run) {
      t = task(:name){ |task|
        arg = task
        1234
      }
      assert_equal "name", t.name

      t1 = task(:t1 => [:t2, :t3]) { |t| runlist << t.name; 3321 }
      task(:t2 => [:t3]) { |t| runlist << t.name }
      task(:t3) { |t| runlist << t.name }
      t1.invoke
    }
  }.new.run

  assert_equal ["t3", "t2", "t1"], runlist
end

assert 'Rake::DSL#file' do
  begin
    runlist = []
    assert_false File.exist?('tmp')
    assert_false File.exist?('old')
    klass = Class.new {
      include Rake::DSL

      define_method(:run) {
        t1 = file('tmp' => ['old']){|t|
          File.open(t.name, 'w') {
            runlist << t.name
          }
        }
        file('old'){|t|
          File.open(t.name, 'w') {
            runlist << t.name
          }
        }
        file('build_config.rb'){|t|
          # never run
          runlist << t.name
        }
        t1.invoke
      }
    }.new.run
    assert_true File.exist?('tmp')
    assert_true File.exist?('old')
    assert_equal ['old','tmp'], runlist
  ensure
    File.unlink 'tmp' if File.exist? 'tmp'
    File.unlink 'old' if File.exist? 'old'
  end
end
