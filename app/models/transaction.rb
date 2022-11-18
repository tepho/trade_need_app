class Transaction < ApplicationRecord

    WITHDRAW = 1
    DEPOSIT = 2
    TRANSFER = 3

    DATA = {
        WITHDRAW => {
            :id => WITHDRAW,
            :description => "Saque"
        },
        DEPOSIT => {
            :id => DEPOSIT,
            :description => "Depósito"
        },
        TRANSFER => {
            :id => TRANSFER,
            :description => "Transferência"
        }
    }

    validates :origin_id, presence: true
    validates :destiny_id, presence: true, if: :is_transfer?
    validates :amount, presence: true, numericality: { greater_than: 0 }
    validates :transaction_type_id, presence: true, length: { minimum: 1, maximum: 3 }
    
    belongs_to :user, foreign_key: "origin_id"

    validate :negative_amount, on: :create

    after_create :execute_transaction


    # Método para fazer as transações
    def execute_transaction
        ActiveRecord::Base.transaction do

            case self.transaction_type_id.to_i
            when Transaction::WITHDRAW

                self.withdrawal_action
            when Transaction::DEPOSIT

                self.deposit_action
            when Transaction::TRANSFER

                self.transfer_action
            else
                errors.add(:base, "Transação inválida")
                raise ActiveRecord::Rollback
            end
        end
    end

    #Ação de saque
    def withdrawal_action
        user_new_amount = self.user
        user_new_amount.balance -= amount
        user_new_amount.save
    end

    #Ação de depósito
    def deposit_action
        user_new_amount = self.user
        user_new_amount.balance += amount
        user_new_amount.save
    end

    #Ação de transferir
    def transfer_action
        tax = self.calculate_tax_amount

        #Origin da transação 
        origin_new_amount = self.user
        origin_new_amount.balance -= amount + tax
        origin_new_amount.save

        #Destino da transação
        destiny_new_amount = User.find(self.destiny_id)
        destiny_new_amount.balance += amount
        destiny_new_amount.save
    end


    # Método para checar se o saldo ira ficar no negativo
    def negative_amount
        tax = 0

        if self.is_deposit?
            return true
        end
        if self.is_transfer?
            tax = self.calculate_tax_amount
        end

        if self.user.balance - (self.amount + tax) < 0
            errors.add(:base, "Valor negativo!")
            throw(:abort)
        end
    end

    private

    #Valido se é do tipo transferência
    def is_transfer?
        self.transaction_type_id.to_i == Transaction::TRANSFER
    end

    #Valido se é do tipo transferência
    def is_deposit?
        self.transaction_type_id.to_i == Transaction::DEPOSIT
    end

    #check qual taxa deve ser aplicada!
    def calculate_tax_amount
        tax = self.amount > 1000 ? 10 : 0

        today = Time.now
        if [0,6].include? (today.wday) || !(today.hour.between?(9,22))
            tax += 7
        else
            tax += 5
        end
        return tax
    end
end
