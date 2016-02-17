Given(/^We have the following insurer rates:$/) do |table|
  @insurers = []
  table.hashes.each do |hash|
    insurer_coverage = InsurerCoverage.new(hash['name'], hash['covers'])
    @insurers << insurer_coverage
  end
end








