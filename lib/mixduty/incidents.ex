defmodule Mixduty.Incidents do
  import Mixduty
  @path "incidents"

  @moduledoc """
  An incident is a normalized, de-duplicated event generated by a PagerDuty integration. It can be thought of as a problem or an issue within your service that needs to be addressed and resolved.

  Incidents can be `triggered`, `acknowledged`, or `resolved`, and are assigned to a user based on the service's escalation policy.

  A triggered incident prompts a notification to be sent to the currently on-call user(s) as defined in the escalation policy used by the service. Incidents are triggered through the Events API.

  Updates to an incident generate log entries that capture the changes to an incident over time, whether these changes were prompted by a user, an integration, or were performed automatically.
  """

  @doc """
  List incidents of an account
  #### Example
      Mixduty.Incidents.list(client)
  """
  def list(client, params \\ [], options \\ []) do
    get("#{@path}", client, params, options)
  end

  @doc """
  Create an incident
  #### Example
      Mixduty.Incident.create("Server is on fire", "P00PBUG", "user@pagerduty.com", client)
  """
  def create(title, service_id, from, client, options \\ %{}) do
    incident_body = %{
      title: title,
      service: %{
        id: service_id,
        type: "service_reference"
      }
    }
    |> Map.merge(options)
    body = %{incident: incident_body}
    client = Map.put(client, :headers, client.headers ++ [{"From", from}])
    post("#{@path}", client, body)
  end
end
