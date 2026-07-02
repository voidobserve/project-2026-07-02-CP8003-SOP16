.PHONY: clean All Project_Title Project_Build

All: Project_Title Project_Build

Project_Title:
	@echo "----------Building project:[ sleep_wakeup - BuildSet ]----------"

Project_Build:
	@make -r -f sleep_wakeup.mk -j 12 -C  ./ 


clean:
	@echo "----------Cleaning project:[ sleep_wakeup - BuildSet ]----------"

