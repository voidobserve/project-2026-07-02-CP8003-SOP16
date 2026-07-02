.PHONY: clean All Project_Title Project_Build

All: Project_Title Project_Build

Project_Title:
	@echo "----------Building project:[ spis - BuildSet ]----------"

Project_Build:
	@make -r -f spis.mk -j 12 -C  ./ 


clean:
	@echo "----------Cleaning project:[ spis - BuildSet ]----------"

