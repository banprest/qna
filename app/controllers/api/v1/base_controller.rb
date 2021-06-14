class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  protected

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end

  private


  def status_and_errors(object)
    render json: object.errors, status: :unprocessable_entity
  end

  def render_json(object)
    render json: object
  end

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
