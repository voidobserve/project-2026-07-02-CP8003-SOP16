.PHONY: clean All Project_Title Project_Build

All: Project_Title Project_Build

Project_Title:
	@echo "----------Building project:[ spim - BuildSet ]----------"

Project_Build:
	@make -r -k -f spim.mk -j 12 -C  ./ 


clean:
	@echo "----------Cleaning project:[ spim - BuildSet ]----------"

