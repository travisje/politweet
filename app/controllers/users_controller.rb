class UsersController < ApplicationController
  protect_from_forgery prepend: true
  before_action :authenticate_user!

end