# below does not work even with python in our path
# Start-Process -FilePath "python" -ArgumentList "C:\Program Files\Opsware\agent\pylibs\cog\uninstall\agent_uninstall.pyc --force" -WorkingDirectory "C:\Program Files\Opsware\agent\pylibs\cog\uninstall\" -Wait -Verbose

# add python to our path and call the uninstall script directly
$env:Path += ";c:\Program Files\Opsware\agent\lcpython15"
python "C:\Program Files\Opsware\agent\pylibs\cog\uninstall\agent_uninstall.pyc" --force