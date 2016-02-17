Given(/^The following request from customer:$/) do |table|
  @customer_request = CustomerRequest.new
  table.hashes.each do |hash|
    @customer_request.add_coverage(hash['part'], hash['value'])
  end
end
