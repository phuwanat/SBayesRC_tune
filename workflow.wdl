version 1.0

workflow SBayesRC_tune {

    meta {
        author: "Phuwanat"
        email: "phuwanat.sak@mahidol.edu"
        description: "SBayesRC tune"
    }

     input {
        File prs1_score_file
        File prs2_score_file
        File keep_id_file
        File pheno_file
        Int memSizeGB = 4
        Int threadCount = 2
        Int diskSizeGB = 20
    }

    call run_checking { 
			input: prs1_score_file=prs1_score_file,prs2_score_file=prs2_score_file,keep_id_file=keep_id_file,pheno_file=pheno_file, memSizeGB=memSizeGB, threadCount=threadCount, diskSizeGB=diskSizeGB
	}

    output {
        Array[File] tune_out = run_checking.tune_out
    }

}

task run_checking {
    input {
        File prs1_score_file
        File prs2_score_file
        File keep_id_file
        File pheno_file
        Int memSizeGB
        Int threadCount
        Int diskSizeGB
    }
    
    command <<<
    
    
    Rscript -e "SBayesRC::sbrcMulti(prs1='~{prs1_score_file}', prs2='~{prs2_score_file}', \
             outPrefix='tune', tuneid='~{keep_id_file}', pheno='~{pheno_file}')"

    >>>

    output {
        Array[File] tune_out = glob("*tune*")
    }

    runtime {
        memory: memSizeGB + " GB"
        cpu: threadCount
        disks: "local-disk " + diskSizeGB + " HDD"
        docker: "phuwanat/sbayesrcmain:v1"  #"zhiliz/sbayesrc:0.2.6"
        preemptible: 1
    }

}
