.PHONY: clean All Project_Title Project_Build

All: Project_Title Project_Build

Project_Title:
	@echo "----------Building project:[ CP8003_REMOTER - BuildSet ]----------"

Project_Build:
	@make -r -f CP8003_REMOTER.mk -j 12 -C  ./ 


clean:
	@echo "----------Cleaning project:[ CP8003_REMOTER - BuildSet ]----------"

