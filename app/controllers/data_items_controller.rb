#
class DataItemsController < ApplicationController
  before_action :authenticate_by_readonly_api_token, except: [:create_by_typeid]
  before_action :authenticate_by_read_write_api_token, only: [:create_by_typeid]

  def list_by_typeid
    items = DataItem.where(typeid: params['typeid'])
    if params[:generated_after]
      items = items.where('generated_at > ?', params[:generated_after])
    end
    if params[:generated_before]
      items = items.where('generated_at < ?', params[:generated_before])
    end
    items = items.order(generated_at: :asc)

    render json: { items: items }
  end

  def create_by_typeid
    typeid = params['typeid']
    raw_post = request.raw_post
    request_body_json = JSON.parse(raw_post)

    data_item = DataItem.create(typeid: typeid, generated_at: request_body_json['generated_at'], data: request_body_json['data'])
    render json: { item: data_item }
  end
end
