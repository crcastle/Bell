module Ohm
  # This module will include all numeric validation needs.
  # As of VERSION 0.0.27, Ohm::NumberValidations#assert_decimal
  # is the only method provided.
  module NumberValidations
    DECIMAL_REGEX = /^(\d+)?(\.\d+)?$/
    PHONE_NUMBER_REGEX = /(([1]{1})([2-9]{1})([0-9]{2})([2-9]{1})([0-9]{2})([0-9]{4}))$/

  protected
    def assert_decimal(att, error = [att, :not_decimal])
      assert_format att, DECIMAL_REGEX, error
    end

    def assert_us_phone(att, error = [att, :not_us_phone])
      assert_format att, PHONE_NUMBER_REGEX, error
    end
  end
end
