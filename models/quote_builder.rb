class QuoteBuilder

  # Only the biggest incoming +NUMBER_OF_VALUES_TO_ACCOUNT_FOR+ values from the customer request are taken into account for the calculation
  NUMBER_OF_VALUES_TO_ACCOUNT_FOR = 3

  # This class will hold the insurer_name, and the number of matches it has in the customer request.
  # Also, it will hold the insurance value WITHOUT any percentage applied.
  #
  class InsurerMatchesAndValue
    def initialize(insurer_name:, number_of_matches:, insurance_value:)
      @insurer_name      = insurer_name
      @number_of_matches = number_of_matches
      @insurance_value   = insurance_value
    end
    attr_reader :insurer_name, :number_of_matches, :insurance_value
  end

  # @param insurers {}
  #
  def initialize(insurers, request)
    @insurers = insurers
    @request  = request
  end

  # The algorithm used here is the following:
  #
  # 1. Take the first X customer request values
  # 2. Then create a table that would have the following items:
  #
  #    Insurer Name, Number of Parts Matched In Customer Request, Insurance Value As Requested By Customer
  #
  # 3. Then we will reject any entries of the above table that have 0 matches or 0 value
  # 4. Then we will sort them by Number of Matches, Insurance Value in descending order both of them.
  #
  # 5. Having that information sorted will make it easy for us to apply percentages based on the number of matches and the position
  #
  def build
    first_cover_items = @request.first(NUMBER_OF_VALUES_TO_ACCOUNT_FOR)

    # insurers with matching items
    matching_insurers = convert_to_table(@insurers, first_cover_items)
    matching_insurers = reject_zero_ones(matching_insurers)
    matching_insurers = sort_by_matches_then_insurance_value(matching_insurers)

    parse_and_build_quotes(matching_insurers)
  end

  private

  # @param insurers [Array{InsurerCoverage}]
  # @param cover_items {Hash} e.g. windes: 10, seats: 15
  #
  # @return a table of objects {InsurerMatchesAndValue}
  #
  def convert_to_table(insurers, cover_items)
    insurers.map {|insurer| InsurerMatchesAndValue.new(insurer_name:      insurer.name,
                                                       number_of_matches: match(insurer, cover_items).size,
                                                       insurance_value:   insurance_value(cover_items, insurer)) }
  end

  # @param insurers [Array{InsurerMatchesAndValue}]
  #
  def reject_zero_ones(insurers)
    insurers.reject {|i| i.number_of_matches.zero? || i.insurance_value.zero?}
  end

  # Sorts the list of objects first by number of matches, then by insurance value.
  # Both in descending order
  #
  # @param insurers [Array{InsurerMatchesAndValue}]
  #
  #
  def sort_by_matches_then_insurance_value(insurers)
    insurers.sort do |a, b|
      result = b.number_of_matches <=> a.number_of_matches
      if result == 0
        b.insurance_value <=> a.insurance_value
      else
        result
      end
    end
  end

  # @param insurer {InsuranceCoverage}
  # @param covers_requested {Hash} e.g. windows: 10, seats: 15
  # @return Returns the number of items that the insurer is matching
  #
  def match(insurer, covers_requested)
    insurer.covers & covers_requested.keys
  end

  # @param cover_items {Hash} - cover: X, value: X
  # @param insurer {InsurerCoverage}
  # @param percentage {Float} e.g. 0.8 for 80%, 0.6 for 60%, e.t.c.
  #
  def insurance_value(cover_items, insurer)
    sum = 0
    insurer.covers.each do |cover|
      sum += cover_items[cover].to_f
    end
    sum
  end

  # @param insurers [ArrayOf{InsurerMatchesAndValue}] Actually this is sorted by number of matches and then by insurance value
  #                                                   in descending order. This is critical because having this order, I can easily
  #                                                   apply the rules of percentage that are affected by the position of the insurer in
  #                                                   this ordering.
  #
  def parse_and_build_quotes(insurers)
    quotes = []
    insurers.each_with_index do |item, index|
      percentage = 1
      if item.number_of_matches >= 2
        percentage = 0.10
      else
        # we have 1 matching
        if index == 0
          percentage = 0.20
        elsif index == 1
          percentage = 0.25
        elsif index == 2
          percentage = 0.30
        end
      end
      quotes << Quote.new(item.insurer_name, item.insurance_value * percentage)
    end
    quotes
  end
end