.PHONY: clean All Project_Title Project_Build

All: Project_Title Project_Build

Project_Title:
	@echo "----------Building project:[ flash - BuildSet ]----------"

Project_Build:
	@make -r -f flash.mk -j 12 -C  ./ 


clean:
	@echo "----------Cleaning project:[ flash - BuildSet ]----------"

