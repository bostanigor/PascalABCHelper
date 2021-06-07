class Api::TasksController < ApiController
  load_and_authorize_resource

  META_PARAMS = %i(page per_page sort).freeze

  def index
    @tasks = @tasks.order(created_at: :desc)
      .sort_query(sort_params)
      .filter_query(index_params.except(*META_PARAMS))

    paginated = params[:page].present? ?
      @tasks.page(params[:page]).per(params[:per_page] || 20) :
      @tasks.all.page(0)

    render 'api/tasks/index', locals: {
      tasks: paginated,
      meta: meta_attributes(paginated)
    }
  end

  def show
    render 'api/tasks/show', locals: {
      task: @task
    }
  end

  def create
    @task = Task.new(create_params)

    if @task.save
      render 'api/tasks/show', locals: {
        task: @task
      }
    else
      render json: {
        errors: @task.errors
      }
    end
  end

  def create_by_file
    contents = parse_file(params[:tasks][:file])
    result = []
    errors = []
    contents.each do |attributes|
      @task = Task.find_or_initialize_by(name: attributes[:name])
      @task.description = attributes[:description]
      if @task.valid?
        result << @task
      else
        errors << @task.errors.full_messages
      end
    end
    if errors.empty?
      result.each(&:save)
      render 'api/tasks/index', locals: {
        tasks: result,
        meta: nil
      }
    else
      render json: { errors: errors }, status: 400
    end
  end

  def update
    if @task.update(create_params)
      render 'api/tasks/show', locals: {
        task: @task
      }
    else
      render json: {
        errors: @task.errors
      }
    end
  end

  def destroy
    if @task.destroy
      render json: {
        data: { message: t('tasks.deleted')}
      }
    else
      render json: {
        data: { errors: @task.errors }
      }
    end
  end

  def batch_destroy
    Task.destroy(params[:ids])
  end

  private

  def index_params
    params.permit(
      :name,
      :description,
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

  def create_params =
    params.require(:task).permit(:name, :description)

  def parse_file(file)
    if file.respond_to?(:read)
      contents = file.read
    elsif file.respond_to?(:path)
      contents = File.read(file.path)
    else
      return nil
    end

    contents.lines.map do |line|
      name, description =
        (line.scan /"([\w+\s]*)"\s*(.*)/).flatten
      {
        name: name,
        description: description
      }
    end
  end
end