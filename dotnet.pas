[Code]

//-----------------------------------------------------------------------------
//  Проверка наличия нужного фреймворка
//-----------------------------------------------------------------------------
function IsDotNetDetected(version: string; service: cardinal): boolean;

var

  reqNetVer: string;
  check45: boolean;
  reg_key: string;
  success: boolean;
  install: cardinal;
  serviceCount: cardinal;
  release: cardinal;

begin

  if version = 'v4.5' then
    begin
        version := 'v4\Full';
        check45 := true;
    end
  else
        check45 := false;

  reg_key := 'SOFTWARE\Microsoft\NET Framework Setup\NDP\' + version;

  if Pos('v3.0', version) = 1 then
    begin
        success := success and RegQueryDWordValue(HKLM, reg_key + '\Setup', 'InstallSuccess', install);
    end
  else
    begin
        success := RegQueryDWordValue(HKLM, reg_key, 'Install', install);
    end;

  if Pos('v4', version) = 1 then
    success := success and RegQueryDWordValue(HKLM, reg_key, 'Servicing', serviceCount)
  else
    success := success and RegQueryDWordValue(HKLM, reg_key, 'SP', serviceCount);

  if check45 then
    begin
        success := success and RegQueryDWordValue(HKLM, reg_key, 'Release', release);
        success := success and (release >= 378389);
    end;

  result := success and (install = 1) and (serviceCount >= service);
end;

