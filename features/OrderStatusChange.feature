  Feature: Order Status Change

    Given a restaurant and a client this feature ensures that business orders are properly updated
    as expected whenever they change their state that is to say orders are made, accepted and ready.

    Example: Users orders "Fritas", then the restaurant "Marco's" should be notified of the request by a notification
    and the system should notify the user the acceptance of it's order, then the business should prepare the food,
    after preparation the system shoud notify the client that it's ready for delivery, notice that the delivery person
    is not involved.

    Scenario Outline: making a new order

        Given <Restaurant-name> is <Restaurant-status>
        When <Client-name> orders <Client-order>
        And <Client-name> order is <validation-status>
        Then the DB <Pre-hook> the <Client-order> order to <Client-order-status>
        And <Post-hook>

        Examples:
          | Client-name | Restaurant-status | Restaurant-name      | Pre-hook    | Client-order     | Validation-status | Client-order-status | Post-hook             |
          | Tiguinho    | Open              | Comida de Mainha     | update      | Fritas de Mainha | validated         | made                | notify <Client-name>  |
          | Maria       | Open              | Fritas do Zé         | fail-update | Happy Potato     | validated         | fail-made           | re-try service        |
          | Cleber      | Closed            | Quentinha do Geraldo | wont-update | Lasanha          | !validated        | wont-made           | !notify <Client-name> |
          |             |                   |                      |             |                  |                   |                     |                       |

    Scenario Outline: receives a new order request

        Given that Comida de Mainha is open
        When Tiguinho orders Fritas de Mainha
        Then Comida de Mainha will be notified of the order
        And Comida de Mainha accept's the order
        And the DB will updated Fritas de Mainha entry to accepted
        And Tiguinho will be notified that the request was accepted by Comida de Mainha

        Given that Comida de Mainha is open
        When Tiguinho orders Fritas de Mainha
        Then Comida de Mainha will be notified of the order
        And Comida de Mainha accept's the order
        And the DB can't update Fritas de Mainha entry to accepted
        And a internal service will be executed re-try the DB update

        Given that Comida de Mainha is open
        When Tiguinho orders Fritas de Mainha
        Then Comida de Mainha will be notified of the order
        And Comida de Mainha won't accept the order
        And the DB will not update Fritas de Mainha status to accepted
        And Tiguinho will be notified that the request wasn't accepted by Comida de Mainha

        Given that Comida de Mainha is closed
        When Tiguinho orders Fritas de Mainha
        Then Comida de Mainha won't be notified of the order
        And the DB musn't add the order as an entry

    Scenario Outline: client is notified that the order is ready

        Given that Comida de Mainha has accepted the request
        When Comida de Mainha confirm in the application that the order is ready
        Then the DB should update order status to ready
        And Tiguinho will be notified that his order is ready

        Given that Comida de Mainha has accepted the request
        When Comida de Mainha hasn't confirmed in the application that the order is ready
        Then the DB can't update the order status to ready
        And Tiguinho won't be notified

    Scenario Outline: test if notifications are sent and received in under 5 min

        Given that Tiguinho has made a order
        When Comida da Mainha confirms the order as <state>
        Then A notification should be sent to Tiguinho
        And must arrive at most 5min later

        Given that Tiguinho has made a order
        When Comida da Mainha confirms the order as <state>
        Then A notification should be sent to Tiguinho
        And will arrive after 5min
        And a service will be executed to re-send the notification

