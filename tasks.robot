*** Settings ***
Library    RPA.Browser.Selenium

*** Variables ***
${MAX_RETRIES}    5

*** Tasks ***
Run things
    ${num_retries}=    Set Variable    0
    WHILE    ${num_retries} <= ${MAX_RETRIES}
        TRY
            # THIS IS WHERE YOU WOULD PUT YOUR ACTUAL CODE
            # Now in this example this just fails everytime.
            FAIL    Error

            # Need to end TRY block with a BREAK in order to exit the loop on success.
            BREAK
        EXCEPT    AS    ${error_message}
            # Depending on the case, it might be necessary to only retry on certain errors that
            # lead to the exponential backoff. In this example we retry on all errors.
            Log    Encountered error ${error_message}, doing exponential backoff.
            ${num_retries}=    Evaluate    ${num_retries} + 1
            IF    ${num_retries} > ${MAX_RETRIES}
                Log    Max retries reached, giving up
                BREAK
            ELSE
                Backoff Before Retry    ${num_retries}
                CONTINUE
            END
        END
    END

*** Keywords ***
Backoff Before Retry
    [Arguments]    ${num_retries}
    # Generate a random jitter value between 100 and 1000 milliseconds
    ${jitter}=     Evaluate    random.sample(range(100, 1000),1)   random
    ${backoff_time}=    Evaluate    2 ** (${num_retries}-1) * 1000 + ${jitter}[0]
    Log    Backing off for ${backoff_time}ms before retrying
    Sleep    ${backoff_time} milliseconds