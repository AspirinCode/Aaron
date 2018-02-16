package AaronOutput;

use strict;

use lib $ENV{'AARON'};

use Constants qw(:INFORMATION :THEORY :PHYSICAL);
use AaronInit qw(%arg_in %arg_parser $system $parent $jobname $ligs_subs);

use Cwd;
use Exporter qw(import);

our @EXPORT = qw(&init_log print_message print_params close_logfile 
                 clean_up print_ee print_status);

my $ol;
my $out_file;
my $old_data;

sub init_log {
    $out_file = $parent . '/' . $jobname . "_aaron.log";
    if (-e $out_file) {
        open $ol, ">>$out_file" or die "Can't open $out_file\n";
        &restart_header();
    }else {
        open $ol, ">>$out_file" or die "Can't open $out_file\n";
        &header();
        &print_params();
    }
}

#Prints Aaron header to $ol.  open STDOUT as $ol to write to screen
sub header {

    my $date = localtime;
    my $version = INFO->{VERSION};
    my @authors = @{ INFO->{AUTHORS} };
    my $year = INFO->{YEAR};

    &print_message("Aaron job started on $date\n\n");

    print $ol "                            Welcome to AARON!\n";
    print $ol "                                (v. $version)\n\n";
    print $ol "                               Written by\n";
    foreach my $author (@authors) {
      print $ol "                            $author\n";
    }
    print $ol "                          Texas A&M University\n";
    print $ol "                         September, 2013 - 2017\n\n";
    print $ol "                                          /\\          /\\ \n";
    print $ol "                                         ( \\\\        // )\n";
    print $ol "                                          \\ \\\\      // / \n";
    print $ol "                                           \\_\\\\||||//_/  \n";
    print $ol "                                            \\/ _  _ \\    \n";
    print $ol "                                           \\/|(O)(O)|    \n";
    print $ol "                                          \\/ |      |    \n";
    print $ol "                      ___________________\\/  \\      /    \n";
    print $ol "                     //  |          |  //     |____|     \n";
    print $ol "                    //   |A.A.R.O.N.| ||     /      \\    \n";
    print $ol "                   //|   |          | \\|     \\ 0  0 /    \n";
    print $ol "                  // \\   ||||||||||||  V    / \\____/     \n";
    print $ol "                 //   \\     /________(   _ /             \n";
    print $ol "                \"\"     \\   /    /    |  ||               \n";
    print $ol "                       /  /\\   /     |  ||               \n";
    print $ol "                      /  / /  /      \\  ||               \n";
    print $ol "                      | |  | |        | ||               \n";
    print $ol "                      |_|  |_|        |_||               \n";
    print $ol "                       \\_\\  \\_\\        \\_\\\\              \n\n\n";
    print $ol "                              Automated\n";
    print $ol "                              Alkylation\n";
    print $ol "                              Reaction\n";
    print $ol "                              Optimizer for\n";
    print $ol "                              New catalyst\n\n";
    print $ol "Citation:\n";
    print $ol "AARON, verson $version, S. E. Wheeler and B. J. Rooks, Texas A&M University, $year.\n\n";
    print $ol "B. J. Rooks, M. R. Haas, D. Sepulveda, T. Lu, and S. E. Wheeler, \"Prospects for the
Co  mputational Design of Bipyridine N,N\'-Dioxide Catalysts for Asymmetric Propargylations\" ACS Catalysis 
5,   272 (2015).\n\n";
    print $ol "The following should also be cited when AARON is used for bidentate Lewis-base catalyzed alkylation reactions:\n\n";
    print $ol "1. T. Lu, M. A. Porterfield, and S. E. Wheeler, \"Explaining the Disparate Stereoselectivities
of   N-Oxide Catalyzed Allylations and Propargylations of Aromatic Aldehydes\", Org. Lett. 14, 
53  10 (2012).\n\n";
    print $ol "2. T. Lu, R. Zhu, Y. An, and S. E. Wheeler, \"Origin of Enantioselectivity in the 
Pr  opargylation of Aromatic Aldehydes Catalyzed by Helical N-Oxides\", J. Am. Chem. Soc. 134, 
30  95 (2012).\n\n";
    print $ol "3. D. Sepulveda, T. Lu, and S. E. Wheeler, \"Performance of DFT Methods and Origin of
St  ereoselectivity in Bipyridine N,N\'-Dioxide Catalyzed Allylation and Propargylation Reactions\", 
12  , 8346 (2014).\n\n";
    print $ol "The development of AARON is sponsored in part by the National Science Foundation,\nGrant CHE-1266022.\n\n\n";
} #end sub header


sub restart_header {
    my $date=localtime;
    if (-e $out_file) {
        print $ol "\n---------------------------------------------------------\nAaron job restarted on $date\n\n";
    } else {
        print $ol "Aaron job restarted on $date\n\n";
        &header();
        &print_params();
    }
}


sub print_message {
    print "$_[0]";
    print $ol "$_[0]";
}


#print all job parameters to $ol
sub print_params {
    my $version = INFO->{VERSION};
    my $AARON_HOME = INFO->{AARON_HOME};
    my $method = $arg_in{level}->method();
    my $high_method = $arg_in{high_level}->method();
    my $low_method = $arg_in{low_level}->method();

    print $ol "----------------------------------------------------------------------------------\n";
    print $ol "Parameters\n";
    print $ol "----------------------------------------------------------------------------------\n";
    print $ol " AARON_HOME          = $AARON_HOME\n";
    print $ol "  version            = $version\n";
    print $ol "\n Reaction parameters:\n";
    print $ol "  reaction_type      = $arg_in{reaction_type}\n";
    print $ol "  solvent            = $arg_in{solvent}\n";
    print $ol "  temperature        = $arg_in{temperature} K\n";
    print $ol "  MaxRTS             = $arg_in{MaxRTS}\n";
    print $ol "  MaxSTS             = $arg_in{MaxSTS}\n";
    print $ol "  TS_path            = $arg_in{TS_path}\n";
    print $ol "\n Methods:\n";
    print $ol "  method = $method\n";
    print $ol "  high level method  = $high_method\n" if $high_method;
    if($arg_in{basis}) {
        print $ol "  basis set file     = $arg_in{basis}\n";
    }
    print $ol "  solvent model      = $arg_in{pcm}\n";
    print $ol "  low-level method   = $low_method\n";
    print $ol "\n Queue parameters:\n";
    print $ol "  wall               = $system->{WALL} hours\n";
    print $ol "  nprocs             = $system->{N_PROCS}\n";
    print $ol "  shortwall          = $system->{SHORT_WALL} hours\n" if $system->{SHORT_WALL};
    print $ol "  shortprocs         = $system->{SHORT_PROCS}\n" if $system->{SHORT_PROCS};
    print $ol "  queue_name         = $system->{QUEUE_NAME}\n" if $system->{QUEUE_NAME};

    if(@ARGV) {
        print $ol "\n command-line flags  = @ARGV\n";
    }
    print $ol "----------------------------------------------------------------------------------\n\n";
} #end sub print_params


sub print_status {

    print "\033[2J";                                              #clear the screen
    print "\033[0;0H";                                    #jump to 0,0
    my $date1=localtime;                          #current date
    
    my $running = 0;

    my $msg = "Status for all jobs...($date1)\n";


    for my $ligand (keys %{ $ligs_subs }) {

        my @start;
        my @running;
        my @done;
        my @finished;
        my @restart;
        my @pending;
        my @killed;
        my @skipped;
        my @repeated;
        my @sleeping;

        my $jobs = $ligs_subs->{$ligand}->{jobs};

        my $_get_job = sub {
            my $geo = shift;

            if (my ($cf) = $geo =~ /(Cf\d+)/) {
                $geo =~ s/\/Cf\d+//;
                return $jobs->{$geo}->{conformers}->{$cf};
            }else {
                return $jobs->{$geo}
            }
        };

        my $_print_status = sub {
            my $job = shift;

            my $geometry = $job->{name};

            STATUS: {
                if ($job->{status} eq 'start') { push(@start, $geometry);
                                                   last STATUS; }

                if ($job->{status} eq 'restart') { push(@restart, $geometry);
                                                     last STATUS; }

                if ($job->{status} eq 'pending') { push(@pending, $geometry);
                                                     last STATUS;}

                if ($job->{status} eq 'done') { push(@done, $geometry);
                                                  last STATUS;}

                if ($job->{status} eq 'finished') { push(@finished, $geometry);
                                                      last STATUS;}

                if ($job->{status} eq 'running') {push(@running, $geometry);
                                                    last STATUS;}

                if ($job->{status} eq 'killed') {push(@killed, $geometry);
                                                    last STATUS;}

                if ($job->{status} eq 'skipped') {push(@skipped, $geometry);
                                                        last STATUS;}

                if ($job->{status} eq 'repeated') {push(@repeated, $geometry);
                                                      last STATUS;}
                if ($job->{status} eq 'sleeping') {push(@sleeping, $geometry);
                                                       last STATUS;}
            }
        };

        $msg .= '-' x 80;
        $msg .= "\nStatus for $ligand jobs......\n";

        foreach my $geometry (sort keys %{ $jobs }) {
            if ($jobs->{$geometry}->{conformers}) {
                for my $cf (keys %{ $jobs->{$geometry}->{conformers} }) {
                    &$_print_status($jobs->{$geometry}->{conformers}->{$cf});
                }
            }else {
                &$_print_status($jobs->{$geometry});
            }
       }


        @start && do {$msg .= "\nThe following jobs are going to start:\n";};
        for my $geometry(@start) {
            $msg .= "$geometry is starting the AARON workflow using geometry from TS libraries\n";
        }

        @done && do {$msg .= "\nThe following jobs are done:\n";};
        for my $geometry(@done) {
            my $job = &$_get_job($geometry);
            my $step_done = $job->{step} - 1;
            $msg .= "$geometry step $step_done is done\n";
        }

        @finished && do {$msg .= "\nThe following AARON are finished: \n";};
        for my $geometry(@finished) {
            $msg .= "$geometry finished normally\n";
        }

        @running && do {$msg .= "\nThe following jobs are running:\n";};
        for my $geometry(@running) {
            my $job = &$_get_job($geometry);
            my $gradient = $job->{gout}->gradient();
            $msg .= "$geometry step $job->{step} attempt $job->{attempt} " .
                    "cycle $job->{cycle}. $gradient\n";
        }

        @pending && do {$msg .= "\nThe following jobs are pending:\n";};
        for my $geometry(@pending) {
            my $job = &$_get_job($geometry);
            $msg .= "$geometry step $job->{step} attempt $job->{attempt}: ";
            $msg .= ($job->{msg} or "No msg recorded") . "\n";
        }

        @restart && do {$msg .= "\nThe following jobs are restarted by some reasons:\n";};
        for my $geometry(@restart) {
            my $job = &$_get_job($geometry);
            $msg .= "$geometry step $job->{step} " .
                    "restarted: ";
            if ($job->{msg}) {
                $msg .= $job->{msg};
            }else {
                $msg .= "No message recorded. ";
            }
            $msg .= "Now at attempt $job->{attempt}, cycle $job->{cycle}.\n";
        }

        @skipped && do {$msg .= "\nThe following jobs are skipped by some error during calculation: \n";};
        for my $geometry(@skipped) {
            my $job = &$_get_job($geometry);
            $msg .= "$geometry step $job->{step} " .
                    "was skipped by reason: \n";
            if ($job->{msg}) {
                $msg .= $job->{msg};
            }else {
                $msg .= "No skipped message recorded\n";
            }
        }

        @killed && do {$msg .= "\nThe following jobs are stopped by reason:\n";};
        for my $geometry(@killed) {
            my $job = &$_get_job($geometry);
            $msg .= "$geometry\n step $job->{step} attemp $job->{attempt}: ";
            $msg .= ($job->{msg} or "No msg recorded") . "\n";
        }

        @repeated && do {$msg .= "\nThe following jobs are repeated conformers:\n";};
        for my $geometry(@repeated) {
            my $job = &$_get_job($geometry);
            $msg .= "$geometry $job->{msg}\n";
        }

        @sleeping && do {$msg .= "\nThe following jobs have not been started and are awaiting other jobs:\n";};
        for my $geometry(@sleeping) {
            $msg .= "$geometry\n";
        }

        print_message('=' x 80);
        print_message("\n$msg\n\n");

    #write status into .sta file

        if (@done || @running || @pending || @restart || @start) {
            $running = 1;
        }
    }
    return $running;
}


sub print_ee {
    my $thermo = shift;

    my $data = '';

    my $print_thermo = sub {
        my %params = @_;
        my ($geo, $thermo, $cf) = ($params{name}, $params{thermo}, $params{cf});


        if ($cf) {
            $data .= sprintf "%6s", $geo;
        }else {
            $data .= sprintf "%-6s", $geo;
        }

        foreach my $thermo (@{$thermo}) {
            $data .= sprintf "%10.1f", $thermo;
        }
        $data .= "\n";
    };

    my @data_keys = sort grep {@{$thermo->{$_}->{sum}}} keys %{ $thermo };

    unless (@data_keys) {
        $data .= "No data yet...\n";
        return $data;
    }else {
        $data .= "\n" . '~' x 90 . "\n";
    }



    my $ee = []; 
    my $er = {};
    if (keys %{ $thermo } == 2) {
        my ($sum1, $sum2) = map { $thermo->{$_}->{sum} } sort keys %{ $thermo };

        for my $i (0..7) {
            if ($sum1->[$i] && $sum2->[$i]) {
                $ee->[$i] = ($sum1->[$i] - $sum2->[$i])/($sum1->[$i] + $sum2->[$i]) * 100
            }
        }
    }elsif (keys %{ $thermo } > 2) {
        my $sum_total = [];

        my @sums = map { $thermo->{$_}->{sum} } sort keys %{ $thermo };

        for my $i (0..7) {
            for my $sum (@sums) {
                $sum_total->[$i] += $sum->[$i] if $sum->[$i];
            }
        }

        for my $key ( sort keys %{ $thermo } ) {
            $er->{$key} = [ map { $thermo->{$key}->{sum}->[$_]/$sum_total->[$_] }
                                (0..$#{ $thermo->{$key}->{sum} }) ];
        }
    }


    if ($arg_in{high_method}) {
        $data .= sprintf "%16s%10s%10s%10s%10s%10s%10s%10s\n", 'E', 'H', 'G', 'G_Grimme',
                                                'E\'', 'H\'', 'G\'', 'G_Grimme\'';
    }else {
        $data .= sprintf "%16s%10s%10s%10s\n", 'E', 'H', 'G', 'G_Grimme',
    }

    if (@$ee) {
        $data .= sprintf "%-6s", 'ee';
        for my $e (@$ee) {
            $data .= sprintf "%9.1f%%", $e;
        }
        $data .= "\n";
    }

    for my $key (@data_keys ) {
        $data .= sprintf "%-6s", $key;
        $data .= "\n";
        $data .= '-' x 86 . "\n";
        if (%{ $er }) {
            for my $e (@{ $er->{$key} }) {
                $data .= sprintf "%9.1f%%", $e;
            }
            $data .= "\n";
        }

        for my $geo (sort keys %{ $thermo->{$key}->{geos} }) {
            my $thermo_geo = $thermo->{$key}->{geos}->{$geo};

            $geo = (split(/\//, $geo))[-1];

            &$print_thermo( name => $geo, 
                          thermo => $thermo_geo->{thermo}) if @{ $thermo_geo->{thermo} };


            if ($thermo_geo->{conformers}) {
                for my $cf (sort keys %{ $thermo_geo->{conformers} }) {
                    &$print_thermo ( name => $cf,
                                   thermo => $thermo_geo->{conformers}->{$cf},
                                       cf => 1) if @{ $thermo_geo->{conformers}->{$cf} };
                }
            }
            $data .= '-' x 86 . "\n" if @{ $thermo_geo->{thermo} };
        }
        $data .= "\n";
    }
    return $data;
}

sub clean_up {
    my ($workingfile) = @_;
    my $startdir = cwd;
    chdir ($workingfile) or die "Unable to enter dir $workingfile:$!\n";
    opendir(DIR, ".") or die "Unable to open dir $workingfile:$!\n";
    my @names = readdir(DIR) or die "Unable to read $workingfile:$!\n";
    closedir(DIR);
    for (@names) {
        /^\.+$/ && do {next;};

        -d && do {
            &clean_up($_);
            next;
        };

        /\.xyz/ && do {
            for (@names) {
                /\.job/ && do { system("rm -f $_"); next;};
            }
            next;
        }
    }
    chdir ($startdir);
} #End clean_up


sub close_logfile {
    my $date = localtime;
    print $ol "AARON stopped $date\n";
    close ($ol);
}

1;