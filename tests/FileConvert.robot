*** Settings ***
Test Setup        Prepare Test
Test Teardown     Cleanup Test
Force Tags        FileConvert    smoke    daily    daily_valgrind
Library           OperatingSystem
Library           String
Library           lib/VorpatestLibrary.py

*** Variables ***
${DATADIR}        %{VORPATEST_ROOT_DIR}${/}data${/}Small

*** Test Cases ***
icosa.obj.mesh
    Run Test

icosa.obj.meshb
    Run Test

icosa.obj.eobj
    Run Test

icosa.obj.ply
    Run Test

icosa.obj.off
    Run Test

icosa.obj.geogram
    Run Test

icosa.obj.geogram_ascii
    Run Test

# Note:
# STL format does not save the connections between facets
# It cannot work here
# icosa.obj.stl
#    Run Test

# Note:
# we don't yet save to XYZ format
# icosa.obj.xyz
#    Run Test


*** Keywords ***
Run Test
    [Arguments]    ${input_name}=${TEST NAME}    @{options}
    [Documentation]    Converts a file to another format
    ...    The name of the input file is taken from the test name.
    ${base_name}     ${ext_from}    ${ext_to} =    Split String From Right    ${input_name}    .
    run command    vorpalite    profile=convert    remesh=false    @{options}    ${DATADIR}${/}${base_name}.${ext_from}    out.${ext_to}
    run command    vorpacomp    tolerance=0.000001    ${DATADIR}${/}${base_name}.${ext_from}    out.${ext_to}

