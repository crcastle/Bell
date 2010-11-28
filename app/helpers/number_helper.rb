class Main
  helpers do
    # accept an 11 character string 12064444344 and
    # format it like a N.A. phone number +1 (206) 444-4344
    def format_number(number)
      number = number.to_s
      if number.length == 11
        number.insert(-5, '-')
        number.insert(4, ' ')
        number.insert(4, ')')
        number.insert(1, '(')
        number.insert(1, ' ')
        number.insert(0, '+')
      elsif number.length == 10
        number.insert(-5, '-')
        number.insert(3, ' ')
        number.insert(3, ')')
        number.insert(0, '(')
      else
        number
      end
    end
  end
end