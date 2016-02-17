Feature: Customer asks and gets back a car insurance quote
  As a Customer
  I want to be able to submit a car insurance request
  So that I can pick up one and insure my car

  # TODO: Think about Scenario Outlines here

  Scenario: Ask for a quote 1
    Given The following request from customer:
      | part     | value |
      | tires    | 10    |
      | windows  | 50    |
      | engine   | 20    |
      | contents | 30    |
      | doors    | 15    |
    And We have the following insurer rates:
      | name      | covers           |
      | insurer_a | windows+contents |
      | insurer_b | tires+contents   |
      | insurer_c | doors+engine     |
    When the request is evaluated
    Then The result should be:
      | name      | value |
      | insurer_a | 8     |
      | insurer_b | 7.5   |
      | insurer_c | 6     |

  Scenario: Ask for a quote when an insurer that does not have match is not take into account
    Given The following request from customer:
      | part     | value |
      | tires    | 10    |
      | windows  | 50    |
      | engine   | 20    |
      | contents | 30    |
      | doors    | 15    |
    And We have the following insurer rates:
      | name      | covers           |
      | insurer_a | windows+contents |
      | insurer_b | tires+contents   |
      | insurer_c | doors+engine     |
      | insurer_d | tires+doors      |
    When the request is evaluated
    Then The result should be:
      | name      | value |
      | insurer_a | 8     |
      | insurer_b | 7.5   |
      | insurer_c | 6     |

  Scenario: Ask for a quote when all insurers have one match
    Given The following request from customer:
      | part     | value |
      | tires    | 10    |
      | windows  | 50    |
      | engine   | 20    |
      | contents | 30    |
      | doors    | 15    |
    And We have the following insurer rates:
      | name      | covers        |
      | insurer_a | windows+tires |
      | insurer_b | tires+engine  |
      | insurer_c | doors+engine  |
    When the request is evaluated
    Then The result should be:
      | name      | value |
      | insurer_a | 10    |
      | insurer_b | 5     |
      | insurer_c | 6     |

  Scenario: Ask for a quote when two insurers have two matches and two having one match
    Given The following request from customer:
      | part     | value |
      | tires    | 10    |
      | windows  | 50    |
      | engine   | 20    |
      | contents | 30    |
      | doors    | 15    |
    And We have the following insurer rates:
      | name      | covers          |
      | insurer_a | windows+engine  |
      | insurer_b | doors+engine    |
      | insurer_c | contents+engine |
      | insurer_d | tires+windows   |
    When the request is evaluated
    Then The result should be:
      | name      | value |
      | insurer_a | 7     |
      | insurer_c | 5     |
      | insurer_d | 15    |
      | insurer_b | 20    |
