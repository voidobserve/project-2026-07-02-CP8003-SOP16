.PHONY: clean All Project_Title Project_Build

All: Project_Title Project_Build

Project_Title:
	@echo "----------Building project:[ gpadc - BuildSet ]----------"

Project_Build:
	@make -r -f gpadc.mk -j 12 -C  ./ 


clean:
	@echo "----------Cleaning project:[ gpadc - BuildSet ]----------"

