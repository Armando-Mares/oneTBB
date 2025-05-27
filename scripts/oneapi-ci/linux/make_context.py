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
sub_component_build = SubComponent(
    Name="release",
    Description="oneTBB",
    ProjectFile="./onetbb-ci/onetbb_source_code/scripts/oneapi-ci/linux/build.sh",
)
sub_component_build.ProjectType = "Script"
sub_component.add(sub_component_build)

cov = Coverity()
cov.Project = "VS-Clang-HWPGO"
cov.Stream = "tompoc"
cov.CompilerTemplates = ["icpx:intel_icx:linux", "icx:intel_icx:linux"]
sub_component.add(cov)

root.add(sub_component)

root.toFile('BuildConfigV2.json')
if bs_version_override:
    with open("bdba_version_override.txt", "w") as f:
        f.write("\n".join([f"{k}: {v}" for k, v in bs_version_override.items()]))

artifacts = [
    {
        "Match": "tcm_source_code/tcm-1.4.0-64-*",
        "Pattern": "(tcm_source_code/)",
        "Replace": ["instal    l-output/"]
    }
]
with open("PackageGen.json", "w") as f:
    json.dump({"intermediate-format": artifacts}, f, indent=2)