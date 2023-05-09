module ApplicationHelper
  def no_table_record(objects = [], columns = 5, message = 'No Records found')
    return "<tr><td colspan='#{columns}' class='text-center'>#{message}</tr>".html_safe if objects.blank?
  end
end
