class User < ApplicationRecord

    include Discard::Model

    attr_accessor :from_date
    attr_accessor :to_date
    
    before_validation :set_defaults
    # authenticates_with_sorcery!

    validates :password, presence: true, length: { minimum: 3 }
    validates :cpf, presence: true, uniqueness: true, length:  { is: 11 }
    validates :email, presence: true
    validates :full_name, presence: true
    
    has_many :transactions
    
    private

    def set_defaults
        self.balance = 0 if self.balance.nil?
    end
end
