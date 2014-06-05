MRuby::Gem::Specification.new('mruby-rake') do |spec|
  spec.rbfiles << Dir.glob("#{dir}/mrblib/rake/*.rb")

  spec.add_dependency "mruby-require"
  spec.license = 'MIT'
  spec.author  = 'ksss <co000ri@gmail.com>'
end
