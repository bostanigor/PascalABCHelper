class Api::GroupsController < ApiController
  before_action :check_admin!
  before_action :set_group, only: [:show, :update, :destroy]

  def index
    @groups = Group.order(created_at: :desc)

    paginated = params[:page].present? ?
      @groups.page(params[:page]).per(params[:per_page] || 20) :
      @groups.all.page(0)

    render 'api/groups/index', locals: {
      groups: paginated,
      meta: meta_attributes(paginated)
    }
  end

  def show
    render 'api/groups/show', locals: {
      group: @group
    }
  end

  def create
    @group = Group.new(create_params.except(:file))

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

  def destroy
    if @group.destroy
      render json: {
        data: { message: t('groups.deleted')}
      }
    else
      render json: {
        data: { errors: @group.errors }
      }
    end
  end

  private

  def create_params
    t = params.require(:group).permit(:name, :file)
    t.merge!({students_attributes: parse_file(t[:file])}) if t[:file].present?
    t
  end

  def parse_file(file)
    if file.respond_to?(:read)
      contents = file.read
    elsif file.respond_to?(:path)
      contents = File.read(file.path)
    else
      return nil
    end

    contents.lines.map do |line|
      first_name, last_name, email =
        (line.scan /"([\w+\s]*)" "([\w+\s]*)" ([\w+\.]+@[\w+\.]+)/).flatten
      {
        first_name: first_name,
        last_name: last_name,
        user_attributes: {
          email: email,
          password: "password"
        }
      }
    end
  end

  def set_group =
    @group = Group.find(params[:id])
end