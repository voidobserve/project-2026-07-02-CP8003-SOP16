##
## Auto Generated makefile by CDK
## Do not modify this file, and any manual changes will be erased!!!   
##
## BuildSet
ProjectName            :=CP8003_REMOTER
ConfigurationName      :=BuildSet
WorkspacePath          :=./
ProjectPath            :=./
IntermediateDirectory  :=Obj
OutDir                 :=$(IntermediateDirectory)
User                   :=PC
Date                   :=02/07/2026
CDKPath                :=../../../../../../app/C-Sky/CDK
ToolchainPath          :=D:/app/C-Sky/CDKRepo/Toolchain/XTGccElfNewlib/V3.4.0/R/
LinkerName             :=riscv64-unknown-elf-gcc
LinkerNameoption       :=
SIZE                   :=riscv64-unknown-elf-size
READELF                :=riscv64-unknown-elf-readelf
CHECKSUM               :=crc32
SharedObjectLinkerName :=
ObjectSuffix           :=.o
DependSuffix           :=.d
PreprocessSuffix       :=.i
DisassemSuffix         :=.asm
IHexSuffix             :=.ihex
BinSuffix              :=.bin
ExeSuffix              :=.elf
LibSuffix              :=.a
DebugSwitch            :=-g 
IncludeSwitch          :=-I
LibrarySwitch          :=-l
OutputSwitch           :=-o 
ElfInfoSwitch          :=-hlS
LibraryPathSwitch      :=-L
PreprocessorSwitch     :=-D
UnPreprocessorSwitch   :=-U
SourceSwitch           :=-c 
ObjdumpSwitch          :=-S
ObjcopySwitch          :=-O ihex
ObjcopyBinSwitch       :=-O binary
OutputFile             :=$(ProjectName)
ObjectSwitch           :=-o 
ArchiveOutputSwitch    := 
PreprocessOnlySwitch   :=-E
PreprocessOnlyDisableLineSwitch   :=-P
ObjectsFileList        :=$(IntermediateDirectory)/CP8003_REMOTER.txt
MakeDirCommand         :=mkdir
LinkOptions            := -mcpu=e902m  -nostartfiles -Wl,--gc-sections -T"$(ProjectPath)/../../../components/core/e902_2g4_sleep.ld" -pipe 
LinkOtherFlagsOption   :=--specs=nano.specs -Wl,-Map=$(ProjectPath)/Lst/$(OutputFile).map 
IncludePackagePath     :=
IncludeCPath           := $(IncludeSwitch). $(IncludeSwitch).. $(IncludeSwitch)../../../../components/ble/app $(IncludeSwitch)../../../../components/ble/ota_service $(IncludeSwitch)../../../../components/ble/service $(IncludeSwitch)../../../../components/driver $(IncludeSwitch)../../../../components/header $(IncludeSwitch)../../../../components/libraries $(IncludeSwitch)../../../../components/libraries/24g $(IncludeSwitch)../../../../components/libraries/ble $(IncludeSwitch)../../../../components/misc $(IncludeSwitch)../../../../modules/ble_viot $(IncludeSwitch)../../../../modules/hal_clock $(IncludeSwitch)../../../components/ble/app $(IncludeSwitch)../../../components/ble/ota_service $(IncludeSwitch)../../../components/ble/service $(IncludeSwitch)../../../components/ble/v0/utils $(IncludeSwitch)../../../components/core/cp8000 $(IncludeSwitch)../../../components/core/riscv/E902 $(IncludeSwitch)../../../components/core/riscv/E902/cp8000 $(IncludeSwitch)../../../components/core/riscv/E902/t1001 $(IncludeSwitch)../../../components/core/t1001 $(IncludeSwitch)../../../components/driver $(IncludeSwitch)../../../components/header $(IncludeSwitch)../../../components/libraries $(IncludeSwitch)../../../components/libraries/24g $(IncludeSwitch)../../../components/libraries/ble $(IncludeSwitch)../../../components/misc $(IncludeSwitch)../../../modules/ble_viot $(IncludeSwitch)../../../modules/hal_adv $(IncludeSwitch)../../../modules/hal_clock $(IncludeSwitch)../../../modules/hal_sleep $(IncludeSwitch)../app_remoter $(IncludeSwitch)../app_viot_handler $(IncludeSwitch)../key_process $(IncludeSwitch)modules/hal_adv $(IncludeSwitch)modules/hal_clock $(IncludeSwitch)modules/hal_gpio $(IncludeSwitch)modules/hal_sleep $(IncludeSwitch)modules/hal_timer $(IncludeSwitch)../../../peripheral_example/FLASH/  
IncludeAPath           := $(IncludeSwitch)../../../../../../app/C-Sky/CDK/CSKY/csi/csi_core/csi_cdk/ $(IncludeSwitch)../../../../../../app/C-Sky/CDK/CSKY/csi/csi_core/include/ $(IncludeSwitch)../../../../../../app/C-Sky/CDK/CSKY/csi/csi_driver/include/ $(IncludeSwitch). $(IncludeSwitch)../../../../components/ble/app $(IncludeSwitch)../../../../components/ble/ota_service $(IncludeSwitch)../../../../components/ble/service $(IncludeSwitch)../../../../components/driver $(IncludeSwitch)../../../../components/header $(IncludeSwitch)../../../../components/libraries $(IncludeSwitch)../../../../components/libraries/24g $(IncludeSwitch)../../../../components/libraries/ble $(IncludeSwitch)../../../../components/misc $(IncludeSwitch)../../../../modules/ble_viot $(IncludeSwitch)../../../../modules/hal_clock $(IncludeSwitch)../../../components/ble/app $(IncludeSwitch)../../../components/ble/ota_service $(IncludeSwitch)../../../components/ble/service $(IncludeSwitch)../../../components/ble/v0/utils $(IncludeSwitch)../../../components/core/cp8000 $(IncludeSwitch)../../../components/core/riscv/E902 $(IncludeSwitch)../../../components/core/riscv/E902/cp8000 $(IncludeSwitch)../../../components/core/riscv/E902/t1001 $(IncludeSwitch)../../../components/core/t1001 $(IncludeSwitch)../../../components/driver $(IncludeSwitch)../../../components/header $(IncludeSwitch)../../../components/libraries $(IncludeSwitch)../../../components/libraries/24g $(IncludeSwitch)../../../components/libraries/ble $(IncludeSwitch)../../../components/misc $(IncludeSwitch)../../../modules/hal_clock $(IncludeSwitch)../app_remoter $(IncludeSwitch)../app_viot_handler $(IncludeSwitch)../key_process $(IncludeSwitch)../../../peripheral_example/FLASH/  
Libs                   :=
ArLibs                 := 
PackagesLibPath        :=
LibPath                := $(PackagesLibPath) 

##
## Common variables
## AR, CXX, CC, AS, CXXFLAGS and CFLAGS can be overriden using an environment variables
##
AR       :=riscv64-unknown-elf-ar rcu
CXX      :=riscv64-unknown-elf-g++
CC       :=riscv64-unknown-elf-gcc
AS       :=riscv64-unknown-elf-gcc
OBJDUMP  :=riscv64-unknown-elf-objdump
OBJCOPY  :=riscv64-unknown-elf-objcopy
CXXFLAGS :=-mcpu=e902m   $(PreprocessorSwitch)BOOT_OTP=0  -Os  -g  -Wall -ffunction-sections -fdata-sections -flto -pipe 
CFLAGS   :=-mcpu=e902m   $(PreprocessorSwitch)BOOT_OTP=0  -Os  -g  -Wall -ffunction-sections -fdata-sections -flto -pipe 
ASFLAGS  :=-mcpu=e902m  -Wa,--gstabs -ffunction-sections -fdata-sections -flto -pipe 
PreprocessFlags  :=-mcpu=e902m   $(PreprocessorSwitch)BOOT_OTP=0  -Os  -g  -Wall -ffunction-sections -fdata-sections -flto -pipe 


Objects0=$(IntermediateDirectory)/CP8003_REMOTER_main$(ObjectSuffix) $(IntermediateDirectory)/CP8003_REMOTER_app_isr$(ObjectSuffix) $(IntermediateDirectory)/CP8003_REMOTER_rmt_key_config$(ObjectSuffix) $(IntermediateDirectory)/app_remoter_app_remoter$(ObjectSuffix) $(IntermediateDirectory)/app_viot_handler_app_viot_handler$(ObjectSuffix) $(IntermediateDirectory)/key_process_key_process$(ObjectSuffix) $(IntermediateDirectory)/driver_driver_clkcal$(ObjectSuffix) $(IntermediateDirectory)/driver_driver_flash$(ObjectSuffix) $(IntermediateDirectory)/driver_driver_gpadc$(ObjectSuffix) $(IntermediateDirectory)/driver_driver_gpio$(ObjectSuffix) \
	$(IntermediateDirectory)/driver_driver_iic$(ObjectSuffix) $(IntermediateDirectory)/driver_driver_ledc$(ObjectSuffix) $(IntermediateDirectory)/driver_driver_spim$(ObjectSuffix) $(IntermediateDirectory)/driver_driver_spis$(ObjectSuffix) $(IntermediateDirectory)/driver_driver_sys$(ObjectSuffix) $(IntermediateDirectory)/driver_driver_timer$(ObjectSuffix) $(IntermediateDirectory)/driver_driver_uart$(ObjectSuffix) $(IntermediateDirectory)/driver_driver_wdt$(ObjectSuffix) $(IntermediateDirectory)/misc_log_dbg$(ObjectSuffix) $(IntermediateDirectory)/hal_clock_hal_clock$(ObjectSuffix) \
	$(IntermediateDirectory)/ble_viot_ble_viot$(ObjectSuffix) 



Objects=$(Objects0) 

##
## Main Build Targets 
##
.PHONY: all
all: $(IntermediateDirectory)/$(OutputFile)

$(IntermediateDirectory)/$(OutputFile):  $(Objects) Always_Link 
	$(LinkerName) $(OutputSwitch) $(IntermediateDirectory)/$(OutputFile)$(ExeSuffix) $(LinkerNameoption) -Wl,-Map=$(ProjectPath)/Lst/$(OutputFile).map  @$(ObjectsFileList) $(LibraryPathSwitch)D:/english_path_floder/remoter/components/libraries $(LibraryPathSwitch)D:/english_path_floder/remoter/components/libraries/24g/20260121/flash $(LibraryPathSwitch)D:/english_path_floder/remoter/components/libraries/24g  -Wl,--whole-archive $(LibrarySwitch)startlib  $(LibrarySwitch)2g4_base  $(LibrarySwitch)rf2g4   -Wl,--no-whole-archive  $(LinkOptions) $(LibPath) $(Libs) $(LinkOtherFlagsOption)
	-@mv $(ProjectPath)/Lst/$(OutputFile).map $(ProjectPath)/Lst/$(OutputFile).temp && $(READELF) $(ElfInfoSwitch) $(ProjectPath)/Obj/$(OutputFile)$(ExeSuffix) > $(ProjectPath)/Lst/$(OutputFile).map && echo ====================================================================== >> $(ProjectPath)/Lst/$(OutputFile).map && cat $(ProjectPath)/Lst/$(OutputFile).temp >> $(ProjectPath)/Lst/$(OutputFile).map && rm -rf $(ProjectPath)/Lst/$(OutputFile).temp
	$(OBJCOPY) $(ObjcopySwitch) $(ProjectPath)/$(IntermediateDirectory)/$(OutputFile)$(ExeSuffix)  $(ProjectPath)/Obj/$(OutputFile)$(IHexSuffix) 
	$(OBJDUMP) $(ObjdumpSwitch) $(ProjectPath)/$(IntermediateDirectory)/$(OutputFile)$(ExeSuffix)  > $(ProjectPath)/Lst/$(OutputFile)$(DisassemSuffix) 
	@echo size of target:
	@$(SIZE) $(ProjectPath)$(IntermediateDirectory)/$(OutputFile)$(ExeSuffix) 
	@echo -n checksum value of target:  
	@$(CHECKSUM) $(ProjectPath)/$(IntermediateDirectory)/$(OutputFile)$(ExeSuffix) 
	@CP8003_REMOTER.modify.bat $(IntermediateDirectory) $(OutputFile)$(ExeSuffix) 

Always_Link:


##
## Objects
##
$(IntermediateDirectory)/CP8003_REMOTER_main$(ObjectSuffix): ../main.c  
	$(CC) $(SourceSwitch) ../main.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/CP8003_REMOTER_main$(ObjectSuffix) -MF$(IntermediateDirectory)/CP8003_REMOTER_main$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/CP8003_REMOTER_main$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/CP8003_REMOTER_main$(PreprocessSuffix): ../main.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/CP8003_REMOTER_main$(PreprocessSuffix) ../main.c

$(IntermediateDirectory)/CP8003_REMOTER_app_isr$(ObjectSuffix): ../app_isr.c  
	$(CC) $(SourceSwitch) ../app_isr.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/CP8003_REMOTER_app_isr$(ObjectSuffix) -MF$(IntermediateDirectory)/CP8003_REMOTER_app_isr$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/CP8003_REMOTER_app_isr$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/CP8003_REMOTER_app_isr$(PreprocessSuffix): ../app_isr.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/CP8003_REMOTER_app_isr$(PreprocessSuffix) ../app_isr.c

$(IntermediateDirectory)/CP8003_REMOTER_rmt_key_config$(ObjectSuffix): ../rmt_key_config.c  
	$(CC) $(SourceSwitch) ../rmt_key_config.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/CP8003_REMOTER_rmt_key_config$(ObjectSuffix) -MF$(IntermediateDirectory)/CP8003_REMOTER_rmt_key_config$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/CP8003_REMOTER_rmt_key_config$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/CP8003_REMOTER_rmt_key_config$(PreprocessSuffix): ../rmt_key_config.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/CP8003_REMOTER_rmt_key_config$(PreprocessSuffix) ../rmt_key_config.c

$(IntermediateDirectory)/app_remoter_app_remoter$(ObjectSuffix): ../app_remoter/app_remoter.c  
	$(CC) $(SourceSwitch) ../app_remoter/app_remoter.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/app_remoter_app_remoter$(ObjectSuffix) -MF$(IntermediateDirectory)/app_remoter_app_remoter$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/app_remoter_app_remoter$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/app_remoter_app_remoter$(PreprocessSuffix): ../app_remoter/app_remoter.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/app_remoter_app_remoter$(PreprocessSuffix) ../app_remoter/app_remoter.c

$(IntermediateDirectory)/app_viot_handler_app_viot_handler$(ObjectSuffix): ../app_viot_handler/app_viot_handler.c  
	$(CC) $(SourceSwitch) ../app_viot_handler/app_viot_handler.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/app_viot_handler_app_viot_handler$(ObjectSuffix) -MF$(IntermediateDirectory)/app_viot_handler_app_viot_handler$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/app_viot_handler_app_viot_handler$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/app_viot_handler_app_viot_handler$(PreprocessSuffix): ../app_viot_handler/app_viot_handler.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/app_viot_handler_app_viot_handler$(PreprocessSuffix) ../app_viot_handler/app_viot_handler.c

$(IntermediateDirectory)/key_process_key_process$(ObjectSuffix): ../key_process/key_process.c  
	$(CC) $(SourceSwitch) ../key_process/key_process.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/key_process_key_process$(ObjectSuffix) -MF$(IntermediateDirectory)/key_process_key_process$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/key_process_key_process$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/key_process_key_process$(PreprocessSuffix): ../key_process/key_process.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/key_process_key_process$(PreprocessSuffix) ../key_process/key_process.c

$(IntermediateDirectory)/driver_driver_clkcal$(ObjectSuffix): ../../../../components/driver/driver_clkcal.c  
	$(CC) $(SourceSwitch) ../../../../components/driver/driver_clkcal.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/driver_driver_clkcal$(ObjectSuffix) -MF$(IntermediateDirectory)/driver_driver_clkcal$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/driver_driver_clkcal$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/driver_driver_clkcal$(PreprocessSuffix): ../../../../components/driver/driver_clkcal.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/driver_driver_clkcal$(PreprocessSuffix) ../../../../components/driver/driver_clkcal.c

$(IntermediateDirectory)/driver_driver_flash$(ObjectSuffix): ../../../../components/driver/driver_flash.c  
	$(CC) $(SourceSwitch) ../../../../components/driver/driver_flash.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/driver_driver_flash$(ObjectSuffix) -MF$(IntermediateDirectory)/driver_driver_flash$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/driver_driver_flash$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/driver_driver_flash$(PreprocessSuffix): ../../../../components/driver/driver_flash.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/driver_driver_flash$(PreprocessSuffix) ../../../../components/driver/driver_flash.c

$(IntermediateDirectory)/driver_driver_gpadc$(ObjectSuffix): ../../../../components/driver/driver_gpadc.c  
	$(CC) $(SourceSwitch) ../../../../components/driver/driver_gpadc.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/driver_driver_gpadc$(ObjectSuffix) -MF$(IntermediateDirectory)/driver_driver_gpadc$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/driver_driver_gpadc$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/driver_driver_gpadc$(PreprocessSuffix): ../../../../components/driver/driver_gpadc.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/driver_driver_gpadc$(PreprocessSuffix) ../../../../components/driver/driver_gpadc.c

$(IntermediateDirectory)/driver_driver_gpio$(ObjectSuffix): ../../../../components/driver/driver_gpio.c  
	$(CC) $(SourceSwitch) ../../../../components/driver/driver_gpio.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/driver_driver_gpio$(ObjectSuffix) -MF$(IntermediateDirectory)/driver_driver_gpio$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/driver_driver_gpio$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/driver_driver_gpio$(PreprocessSuffix): ../../../../components/driver/driver_gpio.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/driver_driver_gpio$(PreprocessSuffix) ../../../../components/driver/driver_gpio.c

$(IntermediateDirectory)/driver_driver_iic$(ObjectSuffix): ../../../../components/driver/driver_iic.c  
	$(CC) $(SourceSwitch) ../../../../components/driver/driver_iic.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/driver_driver_iic$(ObjectSuffix) -MF$(IntermediateDirectory)/driver_driver_iic$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/driver_driver_iic$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/driver_driver_iic$(PreprocessSuffix): ../../../../components/driver/driver_iic.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/driver_driver_iic$(PreprocessSuffix) ../../../../components/driver/driver_iic.c

$(IntermediateDirectory)/driver_driver_ledc$(ObjectSuffix): ../../../../components/driver/driver_ledc.c  
	$(CC) $(SourceSwitch) ../../../../components/driver/driver_ledc.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/driver_driver_ledc$(ObjectSuffix) -MF$(IntermediateDirectory)/driver_driver_ledc$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/driver_driver_ledc$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/driver_driver_ledc$(PreprocessSuffix): ../../../../components/driver/driver_ledc.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/driver_driver_ledc$(PreprocessSuffix) ../../../../components/driver/driver_ledc.c

$(IntermediateDirectory)/driver_driver_spim$(ObjectSuffix): ../../../../components/driver/driver_spim.c  
	$(CC) $(SourceSwitch) ../../../../components/driver/driver_spim.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/driver_driver_spim$(ObjectSuffix) -MF$(IntermediateDirectory)/driver_driver_spim$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/driver_driver_spim$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/driver_driver_spim$(PreprocessSuffix): ../../../../components/driver/driver_spim.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/driver_driver_spim$(PreprocessSuffix) ../../../../components/driver/driver_spim.c

$(IntermediateDirectory)/driver_driver_spis$(ObjectSuffix): ../../../../components/driver/driver_spis.c  
	$(CC) $(SourceSwitch) ../../../../components/driver/driver_spis.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/driver_driver_spis$(ObjectSuffix) -MF$(IntermediateDirectory)/driver_driver_spis$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/driver_driver_spis$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/driver_driver_spis$(PreprocessSuffix): ../../../../components/driver/driver_spis.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/driver_driver_spis$(PreprocessSuffix) ../../../../components/driver/driver_spis.c

$(IntermediateDirectory)/driver_driver_sys$(ObjectSuffix): ../../../../components/driver/driver_sys.c  
	$(CC) $(SourceSwitch) ../../../../components/driver/driver_sys.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/driver_driver_sys$(ObjectSuffix) -MF$(IntermediateDirectory)/driver_driver_sys$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/driver_driver_sys$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/driver_driver_sys$(PreprocessSuffix): ../../../../components/driver/driver_sys.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/driver_driver_sys$(PreprocessSuffix) ../../../../components/driver/driver_sys.c

$(IntermediateDirectory)/driver_driver_timer$(ObjectSuffix): ../../../../components/driver/driver_timer.c  
	$(CC) $(SourceSwitch) ../../../../components/driver/driver_timer.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/driver_driver_timer$(ObjectSuffix) -MF$(IntermediateDirectory)/driver_driver_timer$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/driver_driver_timer$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/driver_driver_timer$(PreprocessSuffix): ../../../../components/driver/driver_timer.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/driver_driver_timer$(PreprocessSuffix) ../../../../components/driver/driver_timer.c

$(IntermediateDirectory)/driver_driver_uart$(ObjectSuffix): ../../../../components/driver/driver_uart.c  
	$(CC) $(SourceSwitch) ../../../../components/driver/driver_uart.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/driver_driver_uart$(ObjectSuffix) -MF$(IntermediateDirectory)/driver_driver_uart$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/driver_driver_uart$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/driver_driver_uart$(PreprocessSuffix): ../../../../components/driver/driver_uart.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/driver_driver_uart$(PreprocessSuffix) ../../../../components/driver/driver_uart.c

$(IntermediateDirectory)/driver_driver_wdt$(ObjectSuffix): ../../../../components/driver/driver_wdt.c  
	$(CC) $(SourceSwitch) ../../../../components/driver/driver_wdt.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/driver_driver_wdt$(ObjectSuffix) -MF$(IntermediateDirectory)/driver_driver_wdt$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/driver_driver_wdt$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/driver_driver_wdt$(PreprocessSuffix): ../../../../components/driver/driver_wdt.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/driver_driver_wdt$(PreprocessSuffix) ../../../../components/driver/driver_wdt.c

$(IntermediateDirectory)/misc_log_dbg$(ObjectSuffix): ../../../../components/misc/log_dbg.c  
	$(CC) $(SourceSwitch) ../../../../components/misc/log_dbg.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/misc_log_dbg$(ObjectSuffix) -MF$(IntermediateDirectory)/misc_log_dbg$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/misc_log_dbg$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/misc_log_dbg$(PreprocessSuffix): ../../../../components/misc/log_dbg.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/misc_log_dbg$(PreprocessSuffix) ../../../../components/misc/log_dbg.c

$(IntermediateDirectory)/hal_clock_hal_clock$(ObjectSuffix): ../../../../modules/hal_clock/hal_clock.c  
	$(CC) $(SourceSwitch) ../../../../modules/hal_clock/hal_clock.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/hal_clock_hal_clock$(ObjectSuffix) -MF$(IntermediateDirectory)/hal_clock_hal_clock$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/hal_clock_hal_clock$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/hal_clock_hal_clock$(PreprocessSuffix): ../../../../modules/hal_clock/hal_clock.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/hal_clock_hal_clock$(PreprocessSuffix) ../../../../modules/hal_clock/hal_clock.c

$(IntermediateDirectory)/ble_viot_ble_viot$(ObjectSuffix): ../../../../modules/ble_viot/ble_viot.c  
	$(CC) $(SourceSwitch) ../../../../modules/ble_viot/ble_viot.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/ble_viot_ble_viot$(ObjectSuffix) -MF$(IntermediateDirectory)/ble_viot_ble_viot$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/ble_viot_ble_viot$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/ble_viot_ble_viot$(PreprocessSuffix): ../../../../modules/ble_viot/ble_viot.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/ble_viot_ble_viot$(PreprocessSuffix) ../../../../modules/ble_viot/ble_viot.c


-include $(IntermediateDirectory)/*$(DependSuffix)
