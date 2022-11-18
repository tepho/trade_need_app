class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    @users = User.all

    render json: {'data':@users , 'meta':{'count':@users.size}}
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: {'error': @user.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: {'error': @user.errors.exception, 'status': @user.errors.status}, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.discard
  end

  # RETURN /users/1 transactions by date
  def extract_by_date
    if params[:from_date].nil? || params[:to_date].nil?
      render json: {'error': "Missing filter filter date"}, status: :unprocessable_entity
    end

    @transaction = Transaction.where(created_at: params[:from_date].to_date.beginning_of_day..params[:to_date].to_date.end_of_day).where("origin_id = #{params[:id]} or destiny_id = #{params[:id]}")

    render json: {'data':@transaction , 'meta':{'count':@transaction.size}}
  end

  # RETURN /users/1 amount
  def account_balance
    @user = User.find(params[:id])
    render json: {'amount':@user.balance }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :cpf, :email, :phone, :birthday, :full_name, :password, :to_date, :from_date)
    end
end
