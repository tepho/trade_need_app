require 'rails_helper' 

describe User do

    context "create basic user" do
        it "create user with full info" do
            user = User.new
            user.full_name = "Pedro A"
            user.cpf = "04998207111"
            user.email = "test@gmail.com"
            user.phone =  "63981475788"
            user.birthday = DateTime.now
            user.password = "123"

            expect(user).to be_valid
        end

        it "shouldnt create user missing info" do
            user = User.new
            user.full_name = "Pedro C"
            user.invalid?
            expect(user.errors).to be_present
        end
    end
end