.PHONY: clean All Project_Title Project_Build

All: Project_Title Project_Build

Project_Title:
	@echo "----------Building project:[ keyscan - BuildSet ]----------"

Project_Build:
	@make -r -f keyscan.mk -j 12 -C  ./ 


clean:
	@echo "----------Cleaning project:[ keyscan - BuildSet ]----------"

