When(/^the request is evaluated$/) do
  # 1. a list of insurers
  # 2. a customer request
  qb = QuoteBuilder.new(@insurers, @customer_request)
  @quotes = qb.build
end

Then(/^The result should be:$/) do |table|
  expect(@quotes.size).to eq(table.hashes.size)

  table.hashes.each do |hash|
    quote = @quotes.select {|q| q.insurer_name == hash['name'] && q.value == hash['value'].to_f }.first
    expect(quote).to_not be_nil, "Problem on insurer: #{hash['name']} with value #{hash['value']}"
  end
end

