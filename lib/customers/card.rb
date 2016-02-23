module Charger
  class Card
    attr_accessor :number, :limit, :is_valid, :balance

    def self.valid?(number:)
      new(number: number).valid?
    end

    def initialize(number:, limit:)
      @balance = 0
      @limit = limit
      @is_valid = luhn_check(number)
    end

    def charge(amount)
      return 'overlimit' if overlimit?(amount)
      @balance += amount
    end

    def credit(amount)
      @balance -= amount
    end

    def overlimit?(amount)
      balance + amount > limit
    end

    def valid?
      is_valid
    end

    def luhn_check(number)
      s1 = s2 = 0
      number.to_s.reverse.chars.each_slice(2) do |odd, even|
        s1 += odd.to_i

        double = even.to_i * 2
        double -= 9 if double >= 10
        s2 += double
      end
      (s1 + s2) % 10 == 0
    end

  end
end
