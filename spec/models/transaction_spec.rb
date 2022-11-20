require 'rails_helper' 

describe Transaction do
    fixtures :all

    context "create basic transaction" do
        it "create transaction of withdraw" do
            user = user(:user_1)

            transaction = Transaction.new
            transaction.origin_id = user.id
            transaction.transaction_type_id = 1
            transaction.amount = 50
            transaction.save

            user = User.find(user.id)
            expect(user.balance).to eq(50)
        end

        it "shouldnt create transaction of withdraw" do
            user = user(:user_1)

            transaction = Transaction.new
            transaction.origin_id = user.id
            transaction.transaction_type_id = 1
            transaction.amount = 500
            transaction.save

            user = User.find(user.id)
            expect(transaction.errors).to be_present
        end

        it "create transaction of deposit" do
            user = user(:user_2)
            transaction = Transaction.new
            transaction.origin_id = user(:user_2).id
            transaction.transaction_type_id = 2
            transaction.amount = 50
            transaction.save

            user2 = User.find(user.id)

            expect(user2.balance).to eq(150)
            expect(transaction.errors).not_to be_present
        end

        it "shouldn create transaction of deposit" do
            user = user(:user_2)
            
            transaction = Transaction.new
            transaction.origin_id = user.id
            transaction.transaction_type_id = 2
            transaction.amount = 0
            transaction.save

            expect(transaction.errors).to be_present
        end

        it "should create transaction of transfer with regular tax" do
            user_origin = user(:user_3)
            user_destiny = user(:user_4)

            travel_to Time.zone.local(2022, 11, 21, 12, 0, 0)

            transaction = Transaction.new
            transaction.origin_id = user_origin.id
            transaction.destiny_id = user_destiny.id
            transaction.transaction_type_id = 3
            transaction.amount = 50
            transaction.save
            user_origin = User.find(user_origin.id)
            user_destiny = User.find(user_destiny.id)

            expect(transaction.errors).to be_empty
            expect(user_origin.balance).not_to eq(100)
            expect(user_origin.balance).not_to eq(100)
            travel_back

        end

        it "should create transaction of transfer with tax other days" do
            user_origin = user(:user_3)
            user_destiny = user(:user_4)

            travel_to Time.zone.local(2022, 11, 20, 12, 0, 0)

            transaction = Transaction.new
            transaction.origin_id = user_origin.id
            transaction.destiny_id = user_destiny.id
            transaction.transaction_type_id = 3
            transaction.amount = 50
            transaction.save
            user_origin = User.find(user_origin.id)
            user_destiny = User.find(user_destiny.id)

            expect(transaction.errors).to be_empty
            expect(user_origin.balance).not_to eq(100)
            expect(user_origin.balance).not_to eq(100)
            travel_back
        end
    end
end