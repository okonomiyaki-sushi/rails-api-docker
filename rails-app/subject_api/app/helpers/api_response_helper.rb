module ApiResponseHelper

  # 200 Success
  def response_success(detail="no message")
    render status: :ok, json: { status: 200, title: "Success", detail: detail }
  end

  # 201 Created
  def response_created(detail="no message")
    render status: :created, json: { status: 201, title: "Created", detail: detail }
  end

  # 400 Bad Request
  def response_bad_request(detail="no message")
    render status: :bad_request, json: { status: 400, title: "Bad Request", detail: detail }
  end

  # 401 Unauthorized
  def response_unauthorized(detail="no message")
    render status: :unauthorized, json: { status: 401, title: "Unauthorized", detail: detail }
  end

  # 404 Not found
  def response_not_found(exception)
    render status: :not_found, json: { status: 404, title: "Not Found", detail: exception}
  end
  
end