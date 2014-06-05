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

