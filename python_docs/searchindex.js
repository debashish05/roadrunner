Search.setIndex({envversion:46,filenames:["accessing_model","api_reference","index","installing_rr","integration","introduction","metabolic","read_write_functions","selecting_values","stability","steady_state","stoichiometric","using_roadrunner","utility_functions","what_is_rr","what_is_sbml"],objects:{"":{roadrunner:[1,0,0,"-"]},"RoadRunner.Compiler":{getCompiler:[1,1,1,""],getCompilerLocation:[1,1,1,""],getDefaultTargetTriple:[1,1,1,""],getHostCPUName:[1,1,1,""],getProcessTriple:[1,1,1,""],getSupportCodeFolder:[1,1,1,""],setCompiler:[1,1,1,""],setCompilerLocation:[1,1,1,""],setSupportCodeFolder:[1,1,1,""]},"RoadRunner.Config":{LOADSBMLOPTIONS_CONSERVED_MOIETIES:[1,3,1,""],LOADSBMLOPTIONS_MUTABLE_INITIAL_CONDITIONS:[1,3,1,""],LOADSBMLOPTIONS_OPTIMIZE_CFG_SIMPLIFICATION:[1,3,1,""],LOADSBMLOPTIONS_OPTIMIZE_DEAD_CODE_ELIMINATION:[1,3,1,""],LOADSBMLOPTIONS_OPTIMIZE_DEAD_INST_ELIMINATION:[1,3,1,""],LOADSBMLOPTIONS_OPTIMIZE_GVN:[1,3,1,""],LOADSBMLOPTIONS_OPTIMIZE_INSTRUCTION_COMBINING:[1,3,1,""],LOADSBMLOPTIONS_OPTIMIZE_INSTRUCTION_SIMPLIFIER:[1,3,1,""],LOADSBMLOPTIONS_READ_ONLY:[1,3,1,""],LOADSBMLOPTIONS_RECOMPILE:[1,3,1,""],LOADSBMLOPTIONS_USE_MCJIT:[1,3,1,""],SIMULATEOPTIONS_MULTI_STEP:[1,3,1,""],getConfigFilePath:[1,2,1,""],readConfigFile:[1,2,1,""],setValue:[1,2,1,""],writeConfigFile:[1,2,1,""]},"RoadRunner.ExecutableModel":{"__getitem__":[1,1,1,""],"__setitem__":[1,1,1,""],getBoundarySpeciesAmounts:[1,1,1,""],getBoundarySpeciesConcentrations:[1,1,1,""],getBoundarySpeciesIds:[1,1,1,""],getCompartmentIds:[1,1,1,""],getCompartmentVolumes:[1,1,1,""],getConservedMoietyIds:[1,1,1,""],getConservedMoietyValues:[1,1,1,""],getFloatingSpeciesAmountRates:[1,1,1,""],getFloatingSpeciesAmounts:[1,1,1,""],getFloatingSpeciesConcentrations:[1,1,1,""],getFloatingSpeciesIds:[1,1,1,""],getFloatingSpeciesInitAmountIds:[1,1,1,""],getFloatingSpeciesInitAmounts:[1,1,1,""],getFloatingSpeciesInitConcentrationIds:[1,1,1,""],getFloatingSpeciesInitConcentrations:[1,1,1,""],getGlobalParameterValues:[1,1,1,""],getInfo:[1,1,1,""],getModelName:[1,1,1,""],getNumBoundarySpecies:[1,1,1,""],getNumCompartments:[1,1,1,""],getNumConservedMoieties:[1,1,1,""],getNumFloatingSpecies:[1,1,1,""],getNumGlobalParameters:[1,1,1,""],getNumReactions:[1,1,1,""],getReactionIds:[1,1,1,""],getReactionRates:[1,1,1,""],getStateVector:[1,1,1,""],getStateVectorId:[1,1,1,""],getStateVectorIds:[1,1,1,""],getStateVectorRate:[1,1,1,""],getStoichiometry:[1,1,1,""],getTime:[1,1,1,""],items:[1,1,1,""],keys:[1,1,1,""],reset:[1,1,1,""],setBoundarySpeciesConcentrations:[1,1,1,""],setCompartmentVolumes:[1,1,1,""],setConservedMoietyValues:[1,1,1,""],setFloatingSpeciesAmounts:[1,1,1,""],setFloatingSpeciesConcentrations:[1,1,1,""],setFloatingSpeciesInitAmounts:[1,1,1,""],setFloatingSpeciesInitConcentrations:[1,1,1,""],setGlobalParameterValues:[1,1,1,""],setTime:[1,1,1,""]},"RoadRunner.LoadSBMLOptions":{conservedMoieties:[1,3,1,""],mutableInitialConditions:[1,3,1,""],noDefaultSelections:[1,3,1,""],readOnly:[1,3,1,""],recompile:[1,3,1,""]},"RoadRunner.Logger":{LOG_CRITICAL:[1,3,1,""],LOG_CURRENT:[1,3,1,""],LOG_DEBUG:[1,3,1,""],LOG_ERROR:[1,3,1,""],LOG_FATAL:[1,3,1,""],LOG_INFORMATION:[1,3,1,""],LOG_NOTICE:[1,3,1,""],LOG_TRACE:[1,3,1,""],LOG_WARNING:[1,3,1,""],disableConsoleLogging:[1,2,1,""],disableFileLogging:[1,2,1,""],disableLogging:[1,2,1,""],enableConsoleLogging:[1,2,1,""],enableFileLogging:[1,2,1,""],getColoredOutput:[1,2,1,""],getCurrentLevelAsString:[1,2,1,""],getFileName:[1,2,1,""],getFormattingPattern:[1,2,1,""],getLevel:[1,2,1,""],levelToString:[1,2,1,""],log:[1,2,1,""],setColoredOutput:[1,2,1,""],setFormattingPattern:[1,2,1,""],setLevel:[1,2,1,""],setProperty:[1,2,1,""],stringToLevel:[1,2,1,""]},"RoadRunner.RoadRunner":{conservedMoietyAnalysis:[1,3,1,""],getAvailableIntegrators:[1,1,1,""],getCC:[1,1,1,""],getConfigurationXML:[1,1,1,""],getConservationMatrix:[1,1,1,""],getCurrentSBML:[1,1,1,""],getEE:[1,1,1,""],getEigenValueIds:[1,1,1,""],getExtendedVersionInfo:[1,2,1,""],getFrequencyResponse:[1,1,1,""],getFullEigenValues:[1,1,1,""],getFullJacobian:[1,1,1,""],getFullStoichiometryMatrix:[1,1,1,""],getInfo:[1,1,1,""],getInstanceCount:[1,1,1,""],getInstanceID:[1,1,1,""],getIntegrator:[1,1,1,""],getKMatrix:[1,1,1,""],getL0Matrix:[1,1,1,""],getLinkMatrix:[1,1,1,""],getModel:[1,1,1,""],getNrMatrix:[1,1,1,""],getParamPromotedSBML:[1,2,1,""],getReducedEigenValues:[1,1,1,""],getReducedJacobian:[1,1,1,""],getReducedStoichiometryMatrix:[1,1,1,""],getSBML:[1,1,1,""],getScaledConcentrationControlCoefficientMatrix:[1,1,1,""],getScaledElasticityMatrix:[1,1,1,""],getScaledFloatingSpeciesElasticity:[1,1,1,""],getScaledFluxControlCoefficientMatrix:[1,1,1,""],getSelectedValues:[1,1,1,""],getSteadyStateValues:[1,1,1,""],getUnscaledConcentrationControlCoefficientMatrix:[1,1,1,""],getUnscaledElasticityMatrix:[1,1,1,""],getUnscaledFluxControlCoefficientMatrix:[1,1,1,""],getUnscaledParameterElasticity:[1,1,1,""],getUnscaledSpeciesElasticity:[1,1,1,""],getuCC:[1,1,1,""],getuEE:[1,1,1,""],isModelLoaded:[1,1,1,""],load:[1,1,1,""],model:[1,3,1,""],oneStep:[1,1,1,""],reset:[1,1,1,""],selections:[1,3,1,""],setConfigurationXML:[1,1,1,""],simulate:[1,1,1,""],simulateOptions:[1,3,1,""],steadyState:[1,1,1,""],steadyStateSelections:[1,3,1,""]},"RoadRunner:.Compiler":{getVersion:[1,1,1,""]},"roadrunner.RoadRunner":{"__init__":[1,1,1,""],createSelection:[1,1,1,""],getCompiler:[1,1,1,""],getIds:[1,1,1,""],getValue:[1,1,1,""]},RoadRunner:{Compiler:[1,4,1,""],LoadSBMLOptions:[1,4,1,""],RoadRunner_getCopyright:[1,5,1,""],RoadRunner_getExtendedVersionInfo:[1,5,1,""],RoadRunner_getParamPromotedSBML:[1,5,1,""]},roadrunner:{RoadRunner:[1,4,1,""]}},objnames:{"0":["py","module","Python module"],"1":["py","method","Python method"],"2":["py","staticmethod","Python static method"],"3":["py","attribute","Python attribute"],"4":["py","class","Python class"],"5":["py","function","Python function"]},objtypes:{"0":"py:module","1":"py:method","2":"py:staticmethod","3":"py:attribute","4":"py:class","5":"py:function"},terms:{"0056ac30":1,"0b01":1,"0b10":1,"0b11":1,"0x101c70a00":14,"10e":10,"234567e":10,"4th":12,"54293397e":1,"99954571e":1,"9999999999999997e":12,"__getitem__":1,"__init__":1,"__setitem__":1,"__version__":[12,13],"_j0":1,"_roadrunn":1,"boolean":1,"case":[1,8],"default":[1,4,12,14],"enum":1,"final":[11,14],"import":[1,2,5],"int":[1,12],"long":12,"new":[1,8,12],"return":[1,8,9,10,12,13,14],"static":[1,14],"true":[1,12,14],"try":[1,4,8],abbrevi:1,abl:1,about:[1,2,8,12,13],abov:1,absolut:[1,4,12],absolute_toler:12,accept:[1,2],accessor:[1,14],accomplish:[1,12],accord:12,accordingli:1,actual:[1,8,13],adapt:12,add:[1,12],addit:[1,12,14],addition:12,adjust:4,advac:1,affect:[1,6],after:[1,10,14],again:12,against:12,all:[1,4,6,8,10,12,14],alloc:1,allow:[0,1,4,6,12],almost:8,alreadi:1,also:[1,8,12,13,14],alter:1,altern:12,alwai:[1,8,12],amount:[1,4,8,12,14],amt:14,andi:[1,14],ani:[1,2,6,8,12,13,14],anoth:[4,12],anyth:[1,12],apach:14,appear:8,append:8,appli:12,applic:1,appropri:[1,12],approxim:4,arg:1,argument:[1,4,8,12,13],arrai:[1,2,10,12,14],assembl:1,assig:14,assign:1,assum:[6,12],attach:12,attempt:1,attribut:[1,4],automat:[1,12,14],awar:1,axi:12,back:[1,12,14],backslash:12,backward:12,balanc:4,base:[1,4,13,15],basic:[1,2,5],basicblockpass:1,becaus:[1,6],becom:[1,12],been:[1,4,10,12],befor:[1,4],behavior:1,belong:1,below:[1,12],better:1,between:4,biochem:[9,10],biolog:15,biologi:[14,15],biomd0000000010:12,biomodel:12,bit:1,black:1,block:[1,6,14],blue:1,bool:1,both:1,bound:14,bracket:[8,12],bring:12,brown:1,build:[1,14],built:[1,12,14],cach:1,calcul:[1,4,10,12,14],call:[1,9,10,12,14],caller:1,can:[1,8,10,11,12,13,14,15],cap:12,capabl:[2,12,14],carri:1,cascad:14,caus:[1,12,14],cell:[14,15],centisecond:1,centuri:1,cfg:1,cfgsimplif:1,chain:1,chang:[1,2,5,6,8,10],charact:[1,8,12],check:1,chemic:[1,8,11],child:1,choos:12,chosen:4,clean:14,clear:12,clf:12,clog:1,close:1,cm0:[1,12],cm_1:1,code:[1,13],coeffici:[1,6,8],coefficic:6,color:1,column:[1,8,12,14],combin:[1,11,13],come:6,command:[9,12],comment:1,compar:1,compartment1:1,compat:1,complet:[1,2],compon:14,comput:1,concentr:[1,6,8,10,11,12,14],conf:1,config:1,conservationanalysi:13,conservedmoieti:1,conservedmoietyanalysi:1,conservedmoietyconvert:1,consid:1,consol:[1,12,14],constant:[1,12],construct:1,constructor:[1,12],consum:[1,11],contain:[1,12],content:[1,2,12,14],contini:8,continu:[1,8],convent:[1,8],converg:12,convers:1,convert:1,copi:[1,12,14],copyresult:1,copyright:[1,2,5],corespond:[1,11],correct:12,correspond:1,cost:14,cotemporan:1,could:1,coupl:[2,12],cours:[2,12,14],cpu:1,cpu_typ:1,creat:[1,8],createselect:[1,8],critic:1,criticalcolor:1,current:[1,8,12,13,14],currenttim:1,custom:[1,12],cvode:[1,4,12],cyan:1,cycl:1,dai:1,darkgrai:1,data:[1,2,5],date:[1,13,14],dce:1,dead:1,deadcodeelimin:1,deadinstelimin:1,deal:10,debug:1,debugcolor:1,dec:13,decid:10,decim:1,decreas:4,def:12,default_compart:1,defin:[1,6,8,9,14],definit:[6,14],delet:8,demonstr:14,denot:1,depend:[1,11,14],deriv:8,derivi:6,describ:[1,6,10,11],descript:12,desir:1,detail:[1,12],determin:[1,8,9],determinist:[1,12],dev:13,dictionari:1,did:1,didn:12,differ:[1,12],differenti:[1,4,9,12],directli:[1,2,8,12],directori:[1,12,13,14],disabl:1,disableconsolelog:1,disablefilelog:1,disablelog:1,displai:[1,8,12,14],distribut:[12,14],divid:1,docstr:14,document:[1,4,8,12,14],doe:[1,8,12],don:1,done:1,dot:14,doubl:[1,12],doucment:8,down:[1,4,14],download:12,drastic:4,drive:[1,12],driven:1,ds1:12,ds2:12,durat:[1,12],dure:12,dynam:[1,10,11],each:[1,11,12],easi:[1,9,14],easiest:12,easili:[10,12,14],ebi:12,eclips:13,effect:1,effector:6,effici:1,eig:14,eigen:[1,8],eigensystem:14,eigenvalu:[1,8,9],either:[1,8,12],elast:[1,6,8],element:[1,8,14],elimin:1,empti:1,enabl:1,enablecolor:1,enableconsolelog:1,enablefilelog:1,encount:4,end:[1,12,14],endr:1,engin:[1,2],enter:12,entir:1,environ:1,enzym:6,epoch:1,equal:12,equat:[4,9,10,12,14],error:[1,12],errorcolor:1,escap:12,especi:1,essenti:12,estim:[1,4],etc:1,evalu:[1,4,14],even:[1,8,12],evenli:[1,12],event:[1,12],everi:1,evolv:1,exactli:12,exampl:[1,2,5,8,10,12,13],example_system:1,excel:14,except:[1,4,8,12],executablemodel:[1,14],exist:8,experi:2,experiment:1,express:[1,11],extend:[8,12],extens:1,extern:[1,6],fail:12,fals:[1,12,13],fast:1,fatal:1,fatalcolor:1,featur:[1,2,12],feb:1,februari:1,feedback:[1,12],feel:4,few:12,fewer:1,field:1,file:[1,14],filenam:1,find:1,fine:4,finit:1,first:[1,4,6,11,12,14],fix:12,flag:[1,12],flux:[1,6],folder:13,follow:[0,1,6,7,8,9,10,11,12,13],footnot:[2,5],form:[1,4,6,7,8,11,14],format:[1,12],forth:8,forward:[1,12],found:[1,8,10,12,14],four:1,fraction:1,framework:1,fred:1,free:14,frequenc:1,frequent:[1,4],from:[1,4,9,11,12,13,14],full:[1,9],fulli:12,fundament:[2,5],fundamet:14,futur:1,gain:1,gener:[1,4,8,12],get:[1,2,12,13,14],get_data:14,getavailableintegr:1,getboundaryspeciesamount:1,getboundaryspeciesconcentr:1,getboundaryspeciesid:1,getcc:[1,8],getcoloredoutput:1,getcompartmentid:1,getcompartmentvolum:1,getcompil:1,getcompilerloc:1,getconfigfilepath:1,getconfigurationxml:1,getconservationmatrix:1,getconservedmoietyid:1,getconservedmoietyvalu:1,getcurrentlevelasstr:1,getcurrentsbml:1,getdefaulttargettripl:1,getdescript:12,getdisplaynam:12,gete:[1,8],geteigenvalueid:1,getextendedversioninfo:1,getfilenam:1,getfloatingspeciesamount:[1,14],getfloatingspeciesamountr:1,getfloatingspeciesconcentr:1,getfloatingspeciesid:[1,14],getfloatingspeciesinitamount:1,getfloatingspeciesinitamountid:[1,12],getfloatingspeciesinitconcentr:[1,12],getfloatingspeciesinitconcentrationid:[1,12],getfloatingspeciesinitialamountid:1,getfloatingspeciesinitialconcentrationid:1,getformattingpattern:1,getfrequencyrespons:1,getfulleigenvalu:1,getfulljacobian:[1,9,14],getfullstoichiometrymatrix:1,getglobalparameterid:1,getglobalparametervalu:1,gethint:12,gethostcpunam:1,getid:1,getinfo:[1,13],getinstancecount:1,getinstanceid:1,getintegr:[1,12],getkmatrix:1,getl0matrix:1,getlevel:1,getlinkmatrix:1,getmodel:[1,14],getmodelnam:1,getnrmatrix:1,getnumboundaryspeci:1,getnumcompart:1,getnumconservedmoieti:1,getnumfloatingspeci:1,getnumglobalparamet:1,getnumreact:1,getparampromotedsbml:1,getprocesstripl:1,getreactionid:1,getreactionr:1,getreducedeigenvalu:1,getreducedjacobian:[1,9],getreducedstoichiometrymatrix:1,getroadrunn:12,getsbml:1,getscaledconcentrationcontrolcoefficientmatrix:1,getscaledelasticitymatrix:1,getscaledfloatingspecieselast:1,getscaledfluxcontrolcoefficientmatrix:1,getselectedvalu:1,getset:12,getsimulationdata:12,getstatevector:1,getstatevectorid:1,getstatevectorr:1,getsteadystatesolv:12,getsteadystatevalu:[1,10],getstoichiometri:1,getsupportcodefold:1,gettim:1,getucc:[1,8],getue:1,getunscaledconcentrationcontrolcoefficientmatrix:1,getunscaledelasticitymatrix:1,getunscaledfluxcontrolcoefficientmatrix:1,getunscaledparameterelast:1,getunscaledspecieselast:1,getvalu:[1,8],getvers:1,getversionstr:13,gillespi:[1,12],give:[1,12],given:[1,6,8,9,12,14],gmt:1,good:[1,4],grai:1,green:1,group:2,gvn:1,had:1,hand:4,hard:12,harm:1,hash:1,have:[1,4,8,12,14],help:2,herbert:1,here:[1,2,14],higher:1,highest:[1,4],highli:1,hint:12,histor:1,hold:14,home:[1,12,14],host:1,hour:1,how:[1,6,12,14],howev:[1,4,8,12],html:14,http:[1,3,12,14,15],huge:14,ideal:4,ident:[1,11,14],identif:8,identifi:[1,8],ignor:[1,8,14],imaginari:1,immedi:1,implement:1,implicit:12,imposs:4,improv:1,includ:[1,2,12],increas:4,independ:[1,6,10,11],index:[1,2,8],indic:1,individu:8,info:1,inform:[0,1,2,8,12],informationcolor:1,init:[1,8,12],initial_time_step:12,initialtimestep:[1,4],insert:8,insid:8,inspect:12,instal:2,instanc:[1,12],instancemethod:14,instanti:1,instead:[1,8,9],instruct:[1,3],instructioncombin:1,instructionsimplifi:1,integ:1,integr:[1,2],integratorlisten:1,intend:[1,2],intention:8,interact:[1,14],interchang:11,interfac:14,intern:[1,4,12,14],interpret:[1,8],interv:12,introduc:1,introduct:2,invari:1,invers:8,invok:12,involv:14,ipython:[8,14],ismodelload:1,iso:1,issu:[1,12],item:[1,8],iter:12,ith:9,j0_keq1:8,j4_ks4:8,jac:[9,14],jacobian:[1,9,14],jacobiansteps:1,jan:1,januari:1,just:[1,14],kei:[1,12],kernel:1,key_nam:1,keyword:[1,4,12],kind:[6,15],kinet:[1,12],kutta:12,kwarg:1,label:12,languag:[12,15],larg:[1,4],later:[1,12],law:1,lazi:14,learn:2,legaci:1,legend:[12,14],len:12,length:1,less:[1,10],let:12,leveltostr:1,lib:[1,14],librari:[1,14],libroarunn:1,libsbml:[1,13],libsbmlvers:1,licenc:[2,5],licens:14,lightblu:1,lightcyan:1,lightgreen:1,lightmagenta:1,lightr:1,like:[1,10,12],likewis:6,limit:1,lin:14,linalg:14,line:1,linear:11,linearli:[1,11],linerali:11,link:[1,11],linux:[1,12],list:[1,8,12,14],listen:1,listner:1,llvm:[1,14],load:[1,2,5],loadsbmlopt:1,loadsbmloptions_conserved_moieti:1,loadsbmloptions_mutable_initial_condit:1,loadsbmloptions_optimize_cfg_simplif:1,loadsbmloptions_optimize_dead_code_elimin:1,loadsbmloptions_optimize_dead_inst_elimin:1,loadsbmloptions_optimize_gvn:1,loadsbmloptions_optimize_instruction_combin:1,loadsbmloptions_optimize_instruction_simplifi:1,loadsbmloptions_read_onli:1,loadsbmloptions_recompil:1,loadsbmloptions_use_mcjit:1,loc:1,local:[1,6],localhost:1,locat:[1,13],log_:1,log_crit:1,log_curr:1,log_debug:1,log_error:1,log_fat:1,log_inform:1,log_notic:1,log_trac:1,log_warn:1,logger:1,look:[1,2,14],lowest:1,mac:[1,2],machin:15,magenta:1,mai:[1,2,4,8,11,12],maintain:1,maintin:1,make:1,manag:1,mani:[1,4,8,12,15],manual:2,markup:15,match:1,math:4,mathemat:8,matplotlib:[1,2,12,14],matrix:[1,9,11,14],maximum:[1,12],maximum_adams_ord:12,maximum_bdf_ord:12,maximum_iter:12,maximum_num_step:12,maximum_time_step:12,maximumnumstep:1,maximumtimestep:1,mcjit:1,mcpu:1,mean:[1,12],measur:6,merg:1,messag:1,meth:8,method:0,methodsprovid:13,microsecond:1,microsoft:[13,14],mid:12,midnight:1,might:[1,12],millisecond:1,minimum:1,minimum_damp:12,minimum_time_step:12,minimumtimestep:1,minut:1,mode:1,modelgener:1,modelload:1,modelnam:1,modifi:[1,8],modul:[1,2,12,13],mon:1,mondai:1,monitor:1,month:1,more:[1,2,8,10,12],most:[1,2,4,12,14],msg:1,much:14,multi:1,multi_step:1,multipl:1,multiple_step:12,multistep:1,must:[1,8,12],mutableinitialcondit:1,my_config_fil:1,my_plot:12,myfil:1,mymodel:[2,4,12,14],myparamet:8,name:[1,8,12,14],nativ:14,natur:12,ndarrai:1,necessari:1,necessarili:1,need:[1,4,12,14],needless:4,net:11,network:[6,10,11,15],never:1,newtim:1,next:[1,12],nice:1,nleq:12,nnnn:1,node:1,nodefaultselect:1,nomenclatur:8,non:1,none:[1,12],norm:12,normal:1,notat:[1,12],note:[1,4,8,12],noth:14,notic:[1,14],noticecolor:1,notifi:1,now:[2,12],nullspac:1,number:[1,4,8,11,12,14],numberofdecad:1,numberofpoint:1,numer:[1,4,12,14],numpi:[1,2,12,14],object:[1,2,5,8,12],obtain:[0,1,6,9,10,12],off:[1,12],often:[1,6,10,12],onc:12,onestep:1,onli:[1,8,12],open:[1,14],oper:[1,12,14],operating_system:1,optim:1,orchestr:14,order:[1,8,11,12],ordinari:4,org:[1,3,14,15],origin:[1,8,12],other:[1,4,6,12,14,15],othersiw:8,otherwis:[1,12],out:1,output:[1,2,5],over:[1,4,12,14],overrid:[1,12],own:14,packag:[1,14],pad:1,page:[1,2,3,14],pair:[1,8],param:1,parameterid:[1,8],parameternam:1,pars:1,part:1,partial:6,particular:[1,8],particularli:1,pass:[1,12,13],path:[1,12],pathwai:[1,15],pattern:1,percent:1,perform:[1,4,12,14],perhap:12,period:4,permit:1,pertubr:6,perturb:6,phase:12,plain:1,plan:1,pleas:3,plot:[1,2,5,8],plu:1,poco:1,pocoproject:1,point:[1,12],pointer:14,posit:1,possibl:[8,9,12],potenti:[1,6],power:1,pramet:14,precis:4,preliminari:2,present:1,previou:[1,12],previous:[1,14],print:[1,8,12,13],prioriti:1,problem:4,process:[1,15],processor:1,produc:[1,11],product:[11,14],progag:6,program:1,project:1,prompt:12,properti:[1,2],protocol:1,provid:[1,2,4,14],pure:1,pyd:1,pylab:[12,14],python:[1,12,13,14],queu:1,quickli:1,quot:8,rais:[1,8,12],ran:1,rang:[8,12],rank:[1,11],rational:1,reach:[1,4,12],reaction1:[1,12],reactionid:[1,8],reactionindex:1,reactionindx:1,read:[1,2],readabl:15,readconfigfil:1,readi:12,readonli:1,real:[1,12],realiz:1,recommend:1,recompil:1,record:[1,8],recurs:1,red:1,reduc:[1,11],redund:1,reflect:1,regardless:12,regular:1,regularli:3,regulatori:15,rel:[1,4,12],relat:[1,9,11],relative_toler:12,remain:[1,11,12],rememb:1,remot:1,remov:1,reorder:1,replac:1,repres:[1,8,10,12,14,15],request:8,requir:[4,12],reset:[1,12],resetmodel:1,respect:[1,6],respons:[1,6,14],rest:14,result:[1,2],retriev:[1,10],retriv:8,retun:1,revisit:1,rfc:1,right:1,rk4:12,roadrun:14,roadrunner_config:1,roadrunner_disable_python_dynamic_properti:1,roadrunner_disable_warn:1,roadrunner_getcopyright:1,roadrunner_getextendedversioninfo:1,roadrunner_getparampromotedsbml:1,roadunn:12,roardrunn:14,role:4,root:14,routin:[1,12],row:[1,11],rule:[1,4,8,14],run:[1,2,5],rung:12,safe:1,safetli:1,sai:[1,12],same:[1,12],sampl:1,satisfi:10,sauro:1,scalar:12,scale:1,scipi:2,script:2,search:[1,2],seattl:14,second:[1,12],see:[1,2,8,12],sel:[1,8],selectionrecord:[1,8],selectiontyp:8,self:[12,14],sensit:[6,8],senstiv:6,separ:[1,12],sequenc:8,seri:[1,12],session:14,set:[1,4,8,12,13,14],setboundaryspeciesconcentr:1,setcoloredoutput:1,setcompartmentvolum:1,setcompil:1,setcompilerloc:1,setconfigurationxml:1,setconservedmoietyvalu:1,setfloatingspeciesamount:1,setfloatingspeciesconcentr:1,setfloatingspeciesinitamount:[1,12],setfloatingspeciesinitconcentr:[1,12],setformattingpattern:1,setglobalparametervalu:1,setintegr:12,setlevel:1,setproperti:1,setsupportcodefold:1,settim:1,setvalu:[1,12],shape:12,share:1,shop:1,shortli:1,should:[1,4,9,12],show:[2,12,14],sign:1,signal:15,signific:4,similarli:14,simpl:[1,2,14],simpli:[8,12,14],simplifi:[1,12],simulateopt:1,simulateoptions_multi_step:1,sinc:[1,14],singl:[1,8,10,12,14],singular:[1,9],site:14,situat:9,siutat:6,size:[1,12],slash:[1,12],slightli:12,slow:1,slower:1,small:4,smaller:[1,10,12],smooth:4,solut:[1,10,12],solv:4,solver:[1,2,5],some:[1,6,8,12],someon:[1,8],somogyi:1,sourc:[1,14],space:[1,8,12],span:[1,4],special:1,speciesid:1,speciesindex:1,speciesindx:1,specif:[12,13],specifi:[1,4,8,12],spent:4,spredsheet:14,squar:[1,8,10,12],stabil:[2,4],stabl:4,standard:[2,12,13],start:[1,2,12],startfrequ:1,starttim:1,startup:12,statement:14,statevector:1,statevectorr:1,stderr:1,steadyst:[1,10,12],steadystateselect:[1,10],step:[1,4,6,12],stepsiz:1,stiff:[1,12],stiffer:4,stiochiometri:1,stochast:[1,12],stochiometri:[1,11],stochiometrix:1,stoichiometr:[1,2,8],stop:1,store:[1,8,12],str:[1,12],string:[1,8,12,13,14],stringtolevel:1,structur:[1,11,12,14],structuredresult:[1,12],studi:6,studio:13,subsequ:1,success:[1,10],successfulli:[1,12],suit:12,suitabl:1,sum:[1,10,11],summar:12,sundial:12,support:[1,8,12,13],suppos:14,suppress:1,sure:12,symbol:[1,12],synonym:1,syntax:2,system:[1,4,6,9,10,14,15],tabl:1,take:[1,4,8,14],target:1,task:1,techinqu:14,technic:[2,5],tell:[1,12],templat:1,temporari:13,tendenc:1,term:[1,6,14],termin:[1,14],test:[1,12,14],test_1:[12,14],text:1,textual:1,textur:1,than:[1,12],thei:[1,8],them:[1,12],therefor:[1,10,12],thi:[1,2,4,6,8,10,12,14],thier:1,thing:[1,4],third:1,those:[6,14],though:[1,8],thread:1,three:[1,12],through:[1,6],thu:1,tight:4,tighter:4,time:[1,2,4,8,10,11,12,14],timecours:12,timestep:[1,12],toler:[1,4,12],too:4,top:[1,14],total:4,trace:1,tracecolor:1,transcript:14,treat:[1,8],tripl:1,trivial:1,tue:1,tuesdai:1,tune:[1,4],turn:1,tutori:[2,5],twice:12,two:[1,6,12,14],txt:[1,14],type:[1,8,12,14],typic:[1,8,12,14],ucc:8,uee:8,unchang:6,under:14,unexpect:1,unit:[1,12],univers:14,unix:1,unless:12,unreach:1,unscal:[1,8],updat:[1,3],upon:1,upstream:14,uri:1,uriordocu:1,uriorsbml:1,url:12,usa:14,usedb:1,usehz:1,user:[0,1],usual:1,utc:1,util:2,valid:[1,8],valu:[1,2,4],vari:12,variable_step_s:12,variableid:1,variablenam:1,variablestep:12,varieti:1,variou:[1,6,12],veloc:1,vendor:1,veri:[1,2,4,14],versa:1,version:[1,12,13,14],versionstr_:13,versionstr_bas:13,versionstr_compil:13,versionstr_d:13,versionstr_libsbml:13,via:[1,12],virtual:14,visa:1,visual:13,vmax:1,volum:1,wai:[1,12,14],want:[1,8,12,14],warn:[1,12],warningcolor:1,washington:14,wast:4,websit:3,weekdai:1,weight:12,well:1,were:1,what:[1,2,5,8,10,12],whatev:14,when:[1,10,12,13,14],whenev:[1,12],where:[1,4,6,8,9,10,11,12],wherea:8,whether:12,which:[1,2,4],white:[1,8],whole:1,wide:8,wiki:15,wikipedia:15,window:[1,2],wise:1,wish:12,without:[1,14],word:1,work:[1,12,13],worklist:1,would:[1,10,12],write:[1,2],writeconfigfil:1,written:1,www:[12,14],xml:[1,2,4,12,14,15],year:1,yellow:1,yield:12,you:[1,2,4,12,13,14],your:12,zero:[1,10,12],zone:1},titles:["Accessing the SBML Model Variables","RoadRunner API Reference","libRoadRunner User Guide","Installing RoadRunner","Simulation and Integration","Introduction","Metabolic Control Analysis","SBML Read/Write Functions","Selecting Values","Stability Analysis","Steady State Analysis","Stoichiometric Analysis","Basic Tutorial","Utility Functions","What is libRoadRunner","What Is SBML?"],titleterms:{"class":1,"float":[0,1],"function":[1,7,13],"import":12,accept:8,access:[0,1],analysi:[1,6,9,10,11],api:1,avail:1,basic:12,boundari:[0,1],chang:12,compart:[0,1],compil:1,condit:[0,1,12],configur:1,conserv:1,control:[1,6],copyright:14,data:12,exampl:14,experi:8,footnot:14,fundament:14,global:[0,1],group:13,guid:2,indic:2,inform:13,initi:[0,1,12],instal:3,integr:4,introduct:5,jit:1,level:1,libroadrunn:[2,14],licenc:14,load:12,log:1,mac:3,main:1,manual:3,metabol:[1,6],method:[1,6,8,11],misc:1,model:[0,1,12],moieti:1,object:14,option:1,output:12,overview:2,paramet:[0,1,12],plot:12,preliminari:[4,6,11],properti:8,rate:0,reaction:[0,1],read:7,refer:1,result:8,roadrunn:[1,3,12],run:12,sbml:[0,1,7,15],section:1,select:[1,8,12],simul:[1,4,8,12],solver:12,speci:[0,1],stabil:9,state:[1,10],steadi:[1,10],stochiometr:1,stoichiometr:11,stoichiometri:1,syntax:8,tabl:2,technic:14,tutori:12,user:2,util:13,valu:8,variabl:[0,1],vector:1,what:[14,15],which:8,window:3,write:7}})