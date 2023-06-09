*** Settings ***
Test Setup        Prepare Test
Test Teardown     Cleanup Test
Force Tags        Small    smoke    daily    daily_valgrind
Test Timeout      10 seconds
Library           OperatingSystem
Library           lib/VorpatestLibrary.py

*** Variables ***
${DATADIR}        %{VORPATEST_ROOT_DIR}${/}data${/}Small

*** Test Cases ***
xfail invalid parameter
    Run Fail Test    ${DATADIR}${/}icosa.obj    badparam=1

xfail bad boolean parameter
    Run Fail Test    ${DATADIR}${/}icosa.obj    sys:quiet=xxx

xfail bad integer parameter
    Run Fail Test    ${DATADIR}${/}icosa.obj    remesh:nb_pts=xxx

xfail bad double parameter
    Run Fail Test    ${DATADIR}${/}icosa.obj    remesh:anisotropy=xxx

xfail bad profile
    Run Fail Test    ${DATADIR}${/}icosa.obj    profile=badprofile

xfail missing file arguments
    # NOTE: We cannot use Run Fail Test for this test, because
    # run_vorpaline automatically adds an output file "out.meshb"
    Run Keyword And Expect Error    CalledProcessError: Command*returned non-zero exit status*    run command    vorpalite

xfail too many file arguments
    # NOTE: We make a copy of the input file to the local execution
    # directory to avoid the corruption of input data
    Copy File    ${DATADIR}${/}icosa.obj    icosa.obj
    Run Fail Test    icosa.obj    icosa.obj    icosa.obj

*** Keywords ***
Run Test
    [Arguments]    ${input_name}=${TEST NAME}    @{options}
    [Documentation]    Runs a vorpaline test
    ...    The name of the input file is taken from the test name.
    run vorpaline    ${DATADIR}${/}${input_name}    @{options}

Run Fail Test
    [Arguments]    @{args}
    [Documentation]    Runs a vorpaline test that is expected to fail
    Run Keyword And Expect Error    CalledProcessError: Command*returned non-zero exit status*    run vorpaline    @{args}
