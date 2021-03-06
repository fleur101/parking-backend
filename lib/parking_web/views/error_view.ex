defmodule ParkingWeb.ErrorView do
  use ParkingWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  def render("401.json", _assigns) do
    %{errors: ["invalid login or username"]}
  end
  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: [Phoenix.Controller.status_message_from_template(template)]}
  end
end
