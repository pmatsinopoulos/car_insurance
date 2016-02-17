class CustomerRequest
  def add_coverage(part, value)
    @coverage ||= {}
    @coverage[part] = value
  end

  def first(number_of_items)
    # sort and then return back again as hash
    @coverage.sort_by {|a, b| b}.
        last(number_of_items).
        reduce({}) {|result, item| result[item[0]] = item[1]; result}
  end
end