class Api::GroupsController < ApiController
  before_action :check_admin!
  before_action :set_group, only: [:show, :update]

  def index
    @groups = Group.all.order(created_at: :desc)

    render 'api/groups/index', locals: {
      groups: @groups
    }
  end

  def show
    render 'api/groups/show', locals: {
      group: @group
    }
  end

  def create
    @group = Group.new(create_params)

    if @group.save
      render 'api/groups/show', locals: {
        group: @group
      }
    else
      render json: {
        errors: @group.errors
      }
    end
  end

  def update
    if @group.update(create_params)
      render 'api/groups/show', locals: {
        group: @group
      }
    else
      render json: {
        errors: @group.errors
      }
    end
  end

  private

  def create_params =
    params.require(:group).permit(:name)

  def set_group =
    @group = Group.find(params[:id])
end