.PHONY: clean All Project_Title Project_Build

All: Project_Title Project_Build

Project_Title:
	@echo "----------Building project:[ wdt - BuildSet ]----------"

Project_Build:
	@make -r -f wdt.mk -j 12 -C  ./ 


clean:
	@echo "----------Cleaning project:[ wdt - BuildSet ]----------"

