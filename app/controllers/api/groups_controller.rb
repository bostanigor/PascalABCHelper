class Api::GroupsController < ApiController
  before_action :check_admin!
  before_action :set_group, only: [:show, :update, :destroy]

  META_PARAMS = %i(page per_page sort).freeze

  def index
    @groups = Group.order(created_at: :desc)
      .sort_query(sort_params)
      .filter_query(index_params.except(*META_PARAMS))

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
        errors: @group.errors.to_a
      }, status: 401
    end
  end

  def update
    if @group.update(create_params)
      render 'api/groups/show', locals: {
        group: @group
      }
    else
      render json: {
        errors: @group.errors.to_a
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

  def index_params
    params.permit(
      :name,
      :page,
      :per_page,
      sort: [
        :col,
        :dir
      ]
    )
  end

  def sort_params
    index_params[:sort].to_h.reverse_merge(col: :created_at, dir: :desc)
  end

  def parse_file(file)
    if file.respond_to?(:read)
      contents = file.read
    elsif file.respond_to?(:path)
      contents = File.read(file.path)
    else
      return nil
    end

    counts = Student.all.reduce(Hash.new(0)) do |acc, x|
      acc[x.last_name] += 1
      acc
    end

    contents.lines.map do |line|
      first_name, last_name, username =
        (line.scan /"([\w+\s]*)" "([\w+\s]*)"\s?(\w*)/).flatten
      username = last_name if username.blank?
      counts[username] += 1
      username += "#{counts[username]}" if counts.key? username
      {
        first_name: first_name,
        last_name: last_name,
        user_attributes: {
          username: username,
          password: "password"
        }
      }
    end
  end

  def set_group =
    @group = Group.find(params[:id])
end