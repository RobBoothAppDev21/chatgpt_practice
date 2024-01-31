module FlashHelper
  def classes_for_flash(flash_type)
    case flash_type.to_sym
    when :error
      "bg-red-100 text-red-700"
    when :success
      "bg-green-100 text-green-700"
    when :alert
      "bg-yellow-100 text-yellow-700"
    else
      "bg-blue-100 text-blue-700"
    end
  end
end