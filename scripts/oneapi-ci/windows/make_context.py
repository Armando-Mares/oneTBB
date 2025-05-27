import json

from abi_bdba_scan.scan_binary.buildconfig_binaryscan import BinaryScan
from abi_builder.builder.buildconfig_subcomponent import SubComponent
from abi_core.framework.abi_config_composite import AbiConfigComposite
from abi_core.runtime_context.buildconfig_rtc import RTCConfig
from abi_coverity_scan.coverity_scan.buildconfig_coverity import Coverity

root = AbiConfigComposite(ComponentName="root")

rtc = RTCConfig()
rtc.IngredientName = "tbb_oneapi"
rtc.IngredientVersion = "2022.2.0"
rtc.Description = "Project Config File for oneTBB Ingredient"

root.add(rtc)

bs = BinaryScan()
bs.ServerGroup = "32"
bs.ServerURL = "https://bdba001.icloud.intel.com"
bs.Upload = True
root.add(bs)
bs_version_override = {
    "bzip2": "1.0.9",
}

cov_server = Coverity()
cov_server.ServerURL = "https://coverity.devtools.intel.com/prod15/"
root.add(cov_server)

sub_component = AbiConfigComposite(ComponentName="release")

from pathlib import Path

# Construct the path relative to the current working directory
build_script_path = Path.cwd() / "onetbb-ci" / "onetbb_source_code" / "scripts" / "oneapi-ci" / "windows" / "build_master.bat"

# Use it in your SubComponent
sub_component_build = SubComponent(
    Name="release",
    Description="oneTBB",
    ProjectFile=str(build_script_path),
)

sub_component_build.ProjectType = "Script"
sub_component.add(sub_component_build)

cov = Coverity()
cov.Project = "VS-Clang-HWPGO"
cov.Stream = "tompoc"
cov.CompilerTemplates = ["icpx:intel_icx:windows", "icx:intel_icx:windows"]
sub_component.add(cov)

root.add(sub_component)

root.toFile('BuildConfigV2.json')
if bs_version_override:
    with open("bdba_version_override.txt", "w") as f:
        f.write("\n".join([f"{k}: {v}" for k, v in bs_version_override.items()]))

artifacts = [
    {
        "Match": "artifacts/*",
        "Pattern": "(artifacts/)",
        "Replace": [""]
    }
]
with open("PackageGen.json", "w") as f:
    json.dump({"intermediate-format": artifacts}, f, indent=2)