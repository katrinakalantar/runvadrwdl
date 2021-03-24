version 1.0

workflow vadr{
	input{
		File assembly
		String vadr_options = "-s -r --nomisc --mkey NC_045512 --lowsim5term 2 --lowsim3term 2 --fstlowthr 0.0 --alt_fail lowscore,fsthicnf,fstlocnf"
        File vadr_model = "s3://idseq-public-references/consensus-genome/vadr-models-corona-1.1.3-1.tar.gz"

        String docker_image_id
	}

	call Vadr {
        input:
            assembly = assembly,
            vadr_options = vadr_options,
            vadr_model = vadr_model,
            docker_image_id = docker_image_id
    }

}

task Vadr {
    # Based on original work at https://github.com/AndrewLangvt/genomic_analyses/blob/v0.4.5/tasks/task_ncbi.wdl
    # Requires coronavirus VADR models from https://ftp.ncbi.nlm.nih.gov/pub/nawrocki/vadr-models/coronaviridae/CURRENT/
    input {
        File assembly
        String vadr_options
        File vadr_model
        String docker_image_id
    }

    command <<<
        set -e
        source /etc/profile
        mkdir -p /usr/local/share/vadr/models
        tar xzvf "~{vadr_model}" -C /usr/local/share/vadr/models --strip-components 1
        # find available RAM
        RAM_MB=$(free -m | head -2 | tail -1 | awk '{print $2}')
        # run VADR
        v-annotate.pl ~{vadr_options} --mxsize $RAM_MB "~{assembly}" "vadr-output"
    >>>

    output {
        File vadr_quality = "vadr-output/vadr-output.vadr.sqc"
        File vadr_alerts = "vadr-output/vadr-output.vadr.alt.list"
    }

    runtime {
        docker: docker_image_id
    }
}
